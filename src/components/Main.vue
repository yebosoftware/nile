<script setup lang="ts">
import { RouterView } from 'vue-router';
import Navbar from './Navbar.vue';
import Sidebar from './Sidebar.vue';

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
</style>
