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
            // expand: 'users,turns',
            expand: 'player1',
        });
        games = resultList.items;
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
