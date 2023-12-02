<script lang="ts">
    import Login from "./lib/Login.svelte";
    import TicTacToe from "./lib/TicTacToe.svelte";
    import { currentUser } from "./lib/pocketbase";
</script>

{#if $currentUser}
    <TicTacToe />
{:else}
    <h2>Tic Tac Blitz</h2>
    <Login />
{/if}
