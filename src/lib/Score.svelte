<script lang="ts">
    // import { onMount, onDestroy } from 'svelte';
    // import { pb } from './pocketbase';

    export let name
    export let score
    // let unsubscribeTopPlayers: () => void;

    // onMount(async () => {
    //     const results = await pb.collection('top_players').getList(1,20, {})
    //     topPlayers = results.items

    //     // TODO: the subscription is not working. It does not automatically update on a new win
    //     unsubscribeTopPlayers = await pb
    //       .collection('top_players')
    //       .subscribe('*', async ({ action, record }) => {
    //         console.log(`got event '${action}' for game record ${record}`);
    //         const results = await pb.collection('top_players').getList(1,20, {})
    //         topPlayers = results.items
    //       })
    // })

    // onDestroy(() => {
    //     unsubscribeTopPlayers?.()
    // })
</script>

<div class="score">
    <span>{name}</span>
    <span>{score}</span>
</div>

<style>
	.score {
		display: grid;
		grid-template-columns: repeat(2, 1fr);
		grid-gap: 2px;
	}
</style>

