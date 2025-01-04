<script setup lang="ts">

</script>

<template>
  <div class="navbar">
    <div class="left">Jump</div>
    <div class="right">
      <!-- <i class="fas fa-user"></i>  -->
    </div>
  </div>
</template>

<style scoped>
  .navbar {
    width: 100vw;
    height: 50px;
    background-color: #13253f;
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 0 20px;
  }

  .navbar .left {
    color: white;
  }

  .navbar .right {
    color: white;
    font-size: 24px; /* Icon size */
  }

  .navbar a {
    color: white;
    text-decoration: none;
  }

  .navbar a:hover {
    text-decoration: underline;
  }
</style>
