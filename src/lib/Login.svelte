<script lang="ts">
    import { currentUser, pb } from './pocketbase';

    let username: string;
    let password: string;
    let error: string = "";

    async function login() {
        try {
            await pb.collection('users').authWithPassword(username, password)
        } catch (err) {
            console.log(err)
            error = err
        }
    }

    async function signUp() {
        try {
            const data = {
                username,
                password,
                passwordConfirm: password,
                name: username,
            };
            const createdUser = await pb.collection('users').create(data);
            await login();
        } catch (err) {
            console.log(err)
            error = err
        }
    }

    function signOut() {
        pb.authStore.clear();
    }

</script>

{#if !$currentUser}
    <h2>Tic_tac_blitz</h2>
    <form on:submit|preventDefault>
        <input
            placeholder="Username"
            type="text"
            bind:value={username}
        />
        <input
            placeholder="Password"
            type="password"
            bind:value={password}
        />
        <button on:click={signUp}>Sign Up</button>
        <button on:click={login}>Login</button>
        <p>{error}</p>
    </form>
{/if}
