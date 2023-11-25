<script>
    import { currentUser, pb } from './pocketbase';

	export let position;
    export let mark;
    export let game;
    export let color;

    async function play() {
        await game.play(position)
    }
</script>

<p>
	<span style="background-color: grey; color: {color}" on:click|preventDefault={play}><h2>{mark}</h2></span>
</p>

<style>
	span {
		display: inline-block;
		padding: 0.2em 0.5em;
		margin: 0.5m 0.8em 0.2em 0;
		width: 4em;
		height: 4.5em;
		text-align: center;
		border-radius: 0.2em;
	}
    h2 {
		font-family: 'Monospace';
        font-size: 500%;
		margin: -20px 0 0 0;
    }
</style>
