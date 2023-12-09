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
    <h2>Tic-Tac-Blitz</h2>
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
        <p style="color:red">{error}</p>
        <p>username should be at least 3 characters</p>
        <p>password should be at least 8 characters</p>
    </form>
{/if}
