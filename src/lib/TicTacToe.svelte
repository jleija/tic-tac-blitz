<script lang="ts">
    import { onMount, onDestroy } from 'svelte';
    import { currentUser, pb } from './pocketbase';

    console.log("script");

    let mark: string;
    let position: number;
    let games = [];

    onMount(async () => {
        console.log("on mount");
        const resultList = await pb.collection('games').getList(1,50, {
            sort: 'created',
            expand: 'player1,player2,turns(game)',
        });
        games = resultList.items;
        console.log("mounted games");
        console.log(games);
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
                        <p class="turn-text">{turn.position}{turn.mark} </p>
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

