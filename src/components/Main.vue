<script setup lang="ts">
import { RouterView } from 'vue-router';
import { supabase } from '../lib/supabase'
import Navbar from './Navbar.vue';
import Sidebar from './Sidebar.vue';
import Button from 'primevue/button';
import Menubar from 'primevue/menubar';

console.info(`in main`)
</script>

<template>
  <Navbar></Navbar>
  <div class="container">
    <div class="box">
      <Sidebar></Sidebar>
    </div>
    <div class="box main">
      <RouterView></RouterView>
    </div>
  </div>
</template>

<style scoped>
  .container {
    display: flex;
  }
  .main {
    padding: 20px;
    overflow-y: auto; /* Enable vertical scroll if content overflows */
    height: calc(100vh - 60px); /* Viewport height - Navbar height */
  }
  /* Media query for mobile mode */
  @media (max-width: 768px) {
    .sidebar {
      width: 0px;
    }
  }
</style>
