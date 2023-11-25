<script lang="ts">
    import { onMount, onDestroy } from 'svelte';
    import { currentUser, pb } from './pocketbase';
    import Square from "./Square.svelte";

    console.log("script");

    // let mark: string;
    // let position: number;
    let games = [];
    let positions = [1,2,3,4,5,6,7,8,9];

    let unsubscribeTurns: () => void;
    let unsubscribeGames: () => void;

    function positionMask(position) {
        return 1 << (position - 1)
    }

    function Game(record) {
        this.record = record
        // this.xMask = 0
        // this.oMask = 0
        // this.winningMask = 0

        this.positionPlayed = function(position) {
            console.log("xMask:", this.xMask.toString(2))
            console.log("oMask:", this.oMask.toString(2))
            console.log("posMask:", position, positionMask(position).toString(2))
            console.log("played:", (this.xMask | this.oMask) & positionMask(position).toString(2))
            return ((this.xMask | this.oMask) & positionMask(position)) != 0
        }

        this.turns = function() {
            if ("expand" in this.record && "turns(game)" in this.record.expand) {
                return this.record.expand["turns(game)"]
            }
            return []
        }

        this.gameMaskFor = function(mark) {
            var mask = 0
            var ts = this.turns()
            // console.log("ts:", ts)
            for (let t of ts)
                if (t.mark == mark)
                    mask |= positionMask(t.position)
            return mask
        }

        this.xMask = this.gameMaskFor("x")
        this.oMask = this.gameMaskFor("o")

        const winningMasks = [
            0b111_000_000,
            0b000_111_000,
            0b000_000_111,
            0b100_100_100,
            0b010_010_010,
            0b001_001_001,
            0b100_010_001,
            0b001_010_100
        ]

        this.winningMask = function(gameMask) {
            for (let mask of winningMasks) {
                if ((mask & gameMask) == mask) {
                    return mask
                }
            }
            return 0
        }

        this.turnAtPosition = function(pos) {
            var ts = this.turns()
            // console.log(`turnAtPosition pos: ${pos}`)
            // console.log("ts:", ts)
            for (let t of ts) {
                // console.log("t:", t)
                if (t.position == pos) {
                    return t
                }
            }
            return null
        }

        this.isStrikeThroughPosition = function(pos) {
            // console.log("strike-through:", this.xMask.toString(2))
            // console.log("position-mask:", pos, positionMask(pos).toString(2))
            // console.log("winning-mask:", pos, this.winningMask(this.xMask).toString(2))
            // console.log(this.winningMask(this.xMask)) 
            return ((positionMask(pos) & this.winningMask(this.xMask)) != 0)
                   || ((positionMask(pos) & this.winningMask(this.oMask)) != 0)
        }

        this.isOver = function() {
            return (this.winningMask(this.xMask) != 0) || (this.winningMask(this.oMask) != 0)
        }

        
        this.play = async function(position) {
            if (this.isOver()) {
                console.log("Game Over")
                return
            }

            if (this.positionPlayed(position)) {
                console.log(`Position ${position} already played`)
                return
            }
            
            if ((this.record.player1 != $currentUser.id) && this.record.player2 && (this.record.player2 != $currentUser.id)) {
                console.log("You are not playing this game")
                return
            }

            console.log(`played position ${position} for game ${this}`)
            console.log(`player1: ${this.record.player1} user: ${$currentUser.id}`)
            console.log(this)


            var mark = ""
            if (this.record.player1 == $currentUser.id) {
                mark = "x"
                // this.xMask |= positionMask(position)
            } else {
                // second player joins in
                // if (this.turns().length == 1) {
                if (!this.record.player2) {
                    console.log(`player2 joined in: [${this.record.player2}]`)
                    await pb.collection('games').update(this.record.id, { player2: $currentUser.id })
                    // this.record.player2 = $currentUser.id
                }
                mark = "o"
                // this.oMask |= positionMask(position)
            }

            var ts = this.turns()
            if ((ts.length > 0) && (ts[ts.length-1].mark == mark)) {
                console.log("Not your turn")
                return
            }


            const data = {
                game: this.record.id,
                player: $currentUser.id,
                mark: mark,
                position: position,
            };
            console.log("Creating new play", data)
            // TODO: check this for errors
            await pb.collection('turns').create(data)

            if (mark == "x")
                this.xMask |= positionMask(position)
            else
                this.oMask |= positionMask(position)
        }
    }

    onMount(async () => {
        console.log("on mount");
        const resultList = await pb.collection('games').getList(1,50, {
            sort: 'created',
            // expand: 'turns(game),player1,player2',
            expand: 'turns(game),player1,player2',
        });
        games = resultList.items.map(g => new Game(g));
        console.log("mounted games");
        console.log(games);

        unsubscribeTurns = await pb
          .collection('turns')
          .subscribe('*', async ({ action, record }) => {
            console.log(`got event '${action}' for record ${record}`);
            console.log("record:", record)
            if (action === 'create') {
                console.log(`game: ${record.game}`)
                console.log(`player: ${record.player}`)
                console.log(`mark: ${record.mark}`)
                console.log(`position: ${record.position}`)

                // TODO: turn games into a map maybe 
                //       - or make an map index to games
                for (let i = 0; i < games.length; i++) {
                    if (games[i].record.id == record.game) {
                        console.log("existing game:", games[i])
                        games[i].record.expand["turns(game)"] = [ ...(games[i].turns() || []),  record ]
                        // if ("expand" in games[i] && "turns(game)" in games[i].expand) {
                        //     games[i].expand["turns(game)"] =
                        //         [ ...games[i].expand["turns(game)"], record ] 
                        // } else {
                        //     games[i].expand["turns(game)"] = [ record ]
                        // }
                        console.log(`New board: ${games[i]}`);
                        break;
                    }
                }
              // Fetch associated user
              // const user = await pb.collection('users').getOne(record.user);
              // record.expand = { user };
              // messages = [...messages, record];
            }
          });

        unsubscribeGames = await pb
          .collection('games')
          .subscribe('*', async ({ action, record }) => {
            console.log(`got event '${action}' for game record ${record}`);
            if (action === 'create') {
                console.log(`new game: ${record.id}`)
                console.log(`player1: ${record.player1}`)
                const game = await pb.collection('games').getOne(record.id, {
                    expand: 'turns(game),player1,player2'
                })
                // games = [ ...games, new Game(record) ]
                console.log("recovered game", game)
                games = [ ...games, new Game(game) ]
            }
            if (action === 'delete') {
                console.log(`del game: ${record.id}`)
                console.log(`player1: ${record.player1}`)
                games = games.filter((g) => g.record.id != record.id)
            }
            if (action === 'update') {
                console.log(`update game: ${record.id}`)
                console.log(`player1: ${record.player1}`)
                console.log(`player2: ${record.player2}`)
                var game = games.find((g) => g.record.id == record.id)
                game.record.player1 = record.player1
                game.record.player2 = record.player2
            }
          });
    });

    // Unsubscribe from realtime game turns
    onDestroy(() => {
        unsubscribeTurns?.()
        unsubscribeGames?.()
    });

    async function newGame() {
        console.log("new game")
        const data = {
            player1: $currentUser.id,
        }
        const game = await pb.collection('games').create(data)
    }

    async function del(game) {
        console.log("del game", game)
        await pb.collection('games').delete(game.record.id)
    }

    function testButton() {
        console.log("test button pressed");
    }


</script>

<form on:submit|preventDefault={newGame}>
    <button type="submit">New Game</button>
</form>

{#each games as game}
    <p>x player: {game.record.expand.player1.name} vs o player: {game.record.expand.player2 ? game.record.expand.player2.name : `____[${game.record.expand.player2}]______`} </p>
    <div class="tictactoe">
    {#each positions as position}
        {#if game.turnAtPosition(position) }
            <Square position={position} mark={game.turnAtPosition(position).mark} game={game} color={game.isStrikeThroughPosition(position) ? "red" : "white"}/>
        {:else}
            <Square position={position} mark="" game={game} color="white"/>
        {/if}
    {/each}
    </div>

    <button on:click={() => del(game)}>Delete</button>
{/each}

<style>
	.tictactoe {
		width: 22em;
		display: grid;
		grid-template-columns: repeat(3, 1fr);
		grid-gap: 2px;
        background-color: black;
	}
</style>

