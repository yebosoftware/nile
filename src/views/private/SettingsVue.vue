<script setup lang="ts">

import router from '@/router';
import { supabase } from '../../lib/supabase'

const logout = async () => {
  const { error } = await supabase.auth.signOut()
  if (error) console.log('Error logging out:', error.message)

  router.push({ name: 'login' })
}

</script>

<template>
  <button @click="logout">Logout</button>
  
</template>

<style scoped>

</style>
