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
                        if (games[i].expand["turns(game)"]) {
                            games[i].expand["turns(game)"] =
                                [ ...games[i].expand["turns(game)"], record ] 
                        } else {
                            games[i].expand["turns(game)"] = [ record ]
                        }
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

</script>

<div class="games">
    <h1>Open Games</h1>
    {#each games as game}
        <div class="game">
            <div>
                <p class="game-text">{game.expand.player1.name} </p>
            </div>
        </div>
    {/each}
</div>

<form on:submit|preventDefault={newGame}>
    <button type="submit">Play</button>
</form>

<div class="turns">
    <h1>Turns</h1>
    {#each games as game}
        {#if game.expand["turns(game)"] }
            {#each game.expand["turns(game)"] as turn}
                <div class="turn">
                    <div>
                        <p class="turn-text">{game.id}: {turn.position}{turn.mark} </p>
                    </div>
                </div>
            {/each}
        {/if}
    {/each}
</div>

<form on:submit|preventDefault={newTurn}>
    <input placeholder="Mark" type="text" bind:value={mark} />
    <input placeholder="Position" type="text" bind:value={position} />
    <button type="submit">Turn</button>
</form>

<h1>Photo album</h1>

{#each games as game}
    {@const turns = new Map(game.expand["turns(game)"]?.map(
        (turn) => [turn.position, turn]
    ))}
    {console.log("Game Turns:", turns)}
    <p>You are playing {#if game.player1 == $currentUser.id}x{:else}o{/if}</p>
    <div class="tictactoe">
    {#each positions as position}
        {#if turns.get(position) }
            <Square position={position} mark={turns.get(position).mark} game={game}/>
        {:else}
            <Square position={position} mark="" game={game}/>
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

