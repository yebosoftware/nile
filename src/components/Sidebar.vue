<script setup lang="ts">

</script>

<template>
  <div class="sidebar">
    <ul>
      <li>
        <router-link :to="{ name: 'flows' }">
          <i class="fas fa-home"></i>
          Home
        </router-link>
      </li>
      <li>
        <router-link :to="{ name: 'contact' }">
          <i class="fas fa-envelope"></i> Contact
        </router-link>
      </li>
      <li>
        <router-link :to="{ name: 'settings' }">
          <i class="fas fa-cogs"></i> Settings
        </router-link>
      </li>
    </ul>
  </div>
</template>

<style scoped>
   .sidebar {
    width: 200px;
    height: calc(100vh - 50px);
    background-color: #13253f;
    padding-left: 10px; /* Add padding to prevent text from sticking to the left edge */
  }

  .sidebar a {
    color: white;
    text-decoration: none;
    display: flex;
    align-items: center;
    justify-content: flex-start; /* Ensure alignment to the left */
  }

  .sidebar a:hover {
    text-decoration: underline;
  }

  .sidebar > ul {
    margin: 0px;
    list-style-type: none;
    padding: 0;
  }

  .sidebar > ul > li {
    padding: 10px 0; /* Adjust padding for better spacing */
  }

  /* Adjust icon size and margin */
  .sidebar i {
    margin-right: 10px; /* Space between icon and text */
    font-size: 16px; /* Adjust icon size */
  }
</style>
