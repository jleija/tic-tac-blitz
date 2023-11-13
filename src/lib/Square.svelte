<script>
    import { currentUser, pb } from './pocketbase';

	export let position;
    export let mark;
    export let game;

    function play() {
        if (mark == "") {
            console.log(`played position ${position} for game ${game.id}`)
            console.log(game)
            if (game.player1 == $currentUser.id) {
                mark = "X"
            } else {
                mark = "O"
            }
        } else {
            console.log("This position was already played")
        }
    }
</script>

<p>
	<span style="background-color: grey" on:click={play}><h2>{mark}</h2></span>
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
		color: white;
	}
    h2 {
		font-family: 'Monospace';
        font-size: 500%;
		margin: -20px 0 0 0;
    }
</style>
