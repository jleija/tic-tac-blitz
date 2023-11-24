<script lang="ts">
    import { onMount, onDestroy } from 'svelte';
    import { currentUser, pb } from './pocketbase';
    import Square from "./Square.svelte";

    console.log("script");

    let mark: string;
    let position: number;
    let games = [];
    let positions = [1,2,3,4,5,6,7,8,9];

    let unsubscribeTurns: () => void;
    let unsubscribeGames: () => void;

    function Game(record) {
        this.record = record
        this.gameMask = 0
        this.winningMask = 0
    }

    onMount(async () => {
        console.log("on mount");
        const resultList = await pb.collection('games').getList(1,50, {
            sort: 'created',
            expand: 'player1,player2,turns(game)',
        });
        games = resultList.items;
        console.log("mounted games");
        console.log(games);

        unsubscribeTurns = await pb
          .collection('turns')
          .subscribe('*', async ({ action, record }) => {
            console.log(`got event '${action}' for record ${record}`);
            if (action === 'create') {
                console.log(`game: ${record.game}`)
                console.log(`player: ${record.player}`)
                console.log(`mark: ${record.mark}`)
                console.log(`position: ${record.position}`)

                // TODO: turn games into a map maybe 
                //       - or make an map index to games
                for (var i = 0; i < games.length; i++) {
                    if (games[i].id == record.game) {
                        games[i].expand["turns(game)"] = [ ...(turns(games[i]) || []),  record ]
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
                games = [ ...games, record ]
            }
          });
    });

    // Unsubscribe from realtime game turns
    onDestroy(() => {
        unsubscribeTurns?.();
        unsubscribeGames?.();
    });

    async function newGame() {
        console.log("new game");
        const data = {
            player1: $currentUser.id,
        };
        const game = await pb.collection('games').create(data);
    }

    function testButton() {
        console.log("test button pressed");
    }

    async function newTurn() {
        const data = {
            game: games[0].id,
            player: $currentUser.id,
            mark: mark,
            position: position,
        };
        const play = await pb.collection('turns').create(data);
    }

    function turns(game) {
        if ("expand" in game && "turns(game)" in game.expand) {
            return game.expand["turns(game)"]
        }
        return null
    }

    function turnAtPosition(game, pos) {
        var ts = turns(game)
        if (ts) {
            for (var i = 0; i < ts.length; i++) {
                if (ts[i].position == pos) {
                    return ts[i]
                }
            }
        }
        return null
    }

    function gameMaskFor(mark) {
        var mask = 0
        var ts = turns(game) || []
        for (t in ts)
            if (t.mark == mark)
                mask |= 1 << (t.position - 1)
        return mask
    }

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

    function winningGame() {
        for (mark in ["x", "o"]) {
            var gameMask = gameMaskFor(mark)
            for (winningMask in winningMasks) {
                if (winningMask & gameMask == winningMask) {
                    return [mark, winningMask]
                }
            }
        }
        return null
    }

    function markColors() {
    }

</script>

<form on:submit|preventDefault={newGame}>
    <button type="submit">New Game</button>
</form>

<form on:submit|preventDefault={newTurn}>
    <input placeholder="Mark" type="text" bind:value={mark} />
    <input placeholder="Position" type="text" bind:value={position} />
    <button type="submit">Turn</button>
</form>

{#each games as game}
    {console.log("game:", game)}
    <p>You are playing {#if game.player1 == $currentUser.id}x{:else}{#if game.player2 == $currentUser.id}o{:else}(not playing){/if}{/if}</p>
    <div class="tictactoe">
    {#each positions as position}
        {#if turnAtPosition(game, position) }
            <Square position={position} mark={turnAtPosition(game, position).mark} game={game} color="white"/>
        {:else}
            <Square position={position} mark="" game={game} color="white"/>
        {/if}
    {/each}
    </div>
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

