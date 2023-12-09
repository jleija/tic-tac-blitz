<script>
    import { currentUser, pb } from './pocketbase';

	// export let player1
    // export let player2
    export let game

    async function userName(id) {
        const user = await pb.collection('users').getOne(id, {})
        // console.log("user:", user)
        console.log("user name:", user.name)
        return user.name
    }
    function player2() {
        console.log("------------------------Header::player2")
        let turns = game.record.expand["turns(game)"]
        console.log("game:", game.record.id, "user:", $currentUser.id, "turns in player2:", turns)
        if (turns === undefined || turns === null) {
            console.log("player2=open")
            return "(open)"
        }
        if (turns.length == 0) {
            console.log("player2=open-0")
            return "(open)"
        }
        if (turns[0].player != $currentUser.id) {
            console.log("player2=other", turns[0].player)
            return turns[0].player
        }
        if (turns.length > 1) {
            console.log("player2=second", turns[1].player)
            return turns[1].player
        }
        console.log("player2=open-last")
        return "(open)"
    }
</script>

<p>{game.record.id}</p>
<p>{game.record.expand.player1.id == $currentUser.id ? "me" : game.record.expand.player1.name} vs {player2()}</p>

