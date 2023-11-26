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

<span style="color: {color}" on:click|preventDefault={play}><h2>{mark}</h2></span>

<style>
	span {
		display: inline-block;
		padding: 0.2em 0.5em 0.2em 0.5em;
		margin: 0.1em 0.1em 0.1em 0.1em;
		width: 1em;
		height: 1.5em;
		text-align: center;
		border-radius: 0.2em;
        background-color: grey;
	}
    h2 {
		font-family: 'Monospace';
        font-size: 200%;
		margin: -13px 0 0 0;
    }
</style>
