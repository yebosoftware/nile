<script setup lang="ts">
import { ref } from 'vue';
import { supabase } from '../lib/supabase';
import router from '@/router';

// Reactive state for email, password, and error message
const email = ref('');
const fullName = ref('');
const organization = ref('');
const password = ref('');
const errorMessage = ref('');
const isLoading = ref(false);

async function signUpNewUser() {
  const { data, error } = await supabase.auth.signUp({
    email: email.value,
    password: password.value,
    options: {
      emailRedirectTo: 'https://example.com/welcome',
      data: {
        full_name: fullName.value, // Save full name in user_metadata
        organization_name: organization.value, // Save organization in user_metadata
      },
    },
  })

  
  if (error) return
  
  console.info(data, error )
  router.push({ name: 'confirmation' })
}

</script>

<template>
  <!-- <div>Signup</div>
  <button @click="signUpNewUser">Signup</button>
  <router-link to="/login">Login</router-link> -->
  <div class="login-container">
    <h1>Signup</h1>
    <form @submit.prevent="signUpNewUser" class="login-form">
      <!-- Organization Field -->
      <div class="form-group">
        <label for="organization">Organization</label>
        <input
          id="organization"
          type="text"
          v-model="organization"
          placeholder="Organization"
          required
        />
      </div>

      <!-- Full name Field -->
      <div class="form-group">
        <label for="full_name">Full name</label>
        <input
          id="full_name"
          type="text"
          v-model="fullName"
          placeholder="Full name"
          required
        />
      </div>

      <!-- Email Field -->
      <div class="form-group">
        <label for="email">Email</label>
        <input
          id="email"
          type="email"
          v-model="email"
          placeholder="Enter your email"
          required
        />
      </div>

      <!-- Password Field -->
      <div class="form-group">
        <label for="password">Password</label>
        <input
          id="password"
          type="password"
          v-model="password"
          placeholder="Enter your password"
          required
        />
      </div>

      <!-- Error Message -->
      <p v-if="errorMessage" class="error-message">{{ errorMessage }}</p>

      <!-- Submit Button -->
      <button type="submit" :disabled="isLoading">
        {{ isLoading ? 'Logging in...' : 'Login' }}
      </button>
      <router-link to="/signup">Signup</router-link>
    </form>
  </div>
</template>

<style scoped>
.login-container {
  max-width: 400px;
  margin: 50px auto;
  padding: 20px;
  border: 1px solid #ddd;
  border-radius: 8px;
  background-color: #f9f9f9;
}

.login-container h1 {
  text-align: center;
  margin-bottom: 20px;
}

.form-group {
  margin-bottom: 15px;
}

label {
  display: block;
  margin-bottom: 5px;
  font-weight: bold;
}

input {
  width: 100%;
  padding: 10px;
  font-size: 16px;
  border: 1px solid #ccc;
  border-radius: 4px;
}

button {
  width: 100%;
  padding: 10px;
  font-size: 16px;
  color: #fff;
  background-color: #007bff;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

button:disabled {
  background-color: #aaa;
  cursor: not-allowed;
}

.error-message {
  color: red;
  margin-bottom: 10px;
  text-align: center;
}
</style>