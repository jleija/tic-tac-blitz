<script>
    import { currentUser, pb } from './pocketbase';

	export let player1
    export let player2
    export let game

    async function userName(id) {
        const user = await pb.collection('users').getOne(id, {})
        // console.log("user:", user)
        console.log("user name:", user.name)
        return user.name
    }
</script>

<p>{game.record.expand.player1.id == $currentUser.id ? "me" : game.record.expand.player1.name} vs 
   {(game.record.expand.player2 === null) || (game.record.expand.player2 === undefined) ? "(open)" : (game.record.expand.player2.id == $currentUser.id ? "me" : game.record.expand.player2.name)}
   </p>

