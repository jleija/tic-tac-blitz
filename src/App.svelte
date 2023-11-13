<script lang="ts">
    import Login from "./lib/Login.svelte";
    import TicTacToe from "./lib/TicTacToe.svelte";
    import { currentUser } from "./lib/pocketbase";
</script>

<h1>Tic Tac Toe</h1>

<Login />

{#if $currentUser}
    <TicTacToe />
{/if}
