<script setup lang="ts">

import { onMounted, ref } from 'vue';
import { supabase } from '../../lib/supabase'
import router from '@/router';

interface FlowTemplate {
  is_disabled: boolean;
  id: number;
  title: string;
  route: string;
  query: { type: string; flow_template_id: number };
}

interface Flow {
  id: number;
  name: string;
  flow_templates: { name: string };
  progress: number;
}

const flowTemplates = ref<FlowTemplate[]>([]);
const flows = ref<Flow[]>([]);
const user = ref<{ full_name: string } | null>(null);

onMounted(async () => {
    console.info('here');

  const { data } = await supabase
    .from('flows')
    .select('*, nodes(*), flow_templates(*)')

  console.info(data);
  flows.value = data?.map(flow => ({
    ...flow,
    progress: flow.nodes.filter((node: { latest_upload_id?: number }) => node?.latest_upload_id).length / flow.nodes.length * 100 
  })) || [];

  const { data: flowTemplatesData } = await supabase
    .from('flow_templates')
    .select('*')
    .order('is_disabled', { ascending: true });

  flowTemplates.value = flowTemplatesData?.map(template => ({
    is_disabled: template.is_disabled,
    id: template.id,
    title: template.name,
    route: 'new-application',
    query: { type: 'register', flow_template_id: template.id }
  })) || [];

  getFullName();
});


const getFullName = async () => {
  try {
    // Get the authenticated user
    const {
      data: { user: fetchedUser },
      error: authError,
    } = await supabase.auth.getUser();

    if (authError) {
      throw authError;
    }

    // Fetch the user's profile from the database
    const { data, error } = await supabase
      .from('profiles')
      .select('full_name')
      .eq('id', fetchedUser?.id) // Match the user ID
      .single(); // Retrieve only one record

    if (error) {
      throw error;
    }

    console.log('User full name:', data); 
    user.value = data;
  } catch (err) {
    console.error('Error fetching full name:', err);
    return null;
  }
};

interface Menu {
  is_disabled: boolean;
  id: number;
  title: string;
  route: string;
  query: { type: string; flow_template_id: number };
}

const goTo = (menu: Menu) => {
  if (menu.is_disabled) return;

  router.push({ name: menu.route, query: menu.query });
}
</script>

<template>
  <h3>Welcome back, {{user?.full_name}}!</h3>
  <div class="main-container">
    <div class="menu-container">
      <!-- <router-link :to="{ name: menu.route, query: menu.query }"> -->
        <div @click="goTo(menu)" v-for="menu in flowTemplates" :key="menu.id" class="menu-block" :class="{ is_disabled: menu.is_disabled }">
          <h3>{{ menu.title }}</h3>
          <small v-if="menu.is_disabled">Coming soon</small>
          <small v-else>Click to start</small>
        </div>
      <!-- </router-link> -->

    </div>
    
    <h3>Your applications</h3>
    <ul>
      <li v-for="flow in flows" :key="flow.id">
        <router-link :to="{ name: 'flow', params: { id: flow.id } }">{{ flow.name }} - {{ flow.flow_templates.name }} - {{ flow.progress }}%</router-link>
      </li>
    </ul>
  </div>
  
</template>

<style scoped>
  

  .main-container {
    width: 100%;
  }
  /* Style the menu container to allow blocks to float */
  .menu-container {
    display: flex;
    gap: 1rem;
    flex-wrap: wrap;
    margin-top: 1rem;
  }

  /* Style individual menu blocks */
  .menu-block {
    background-color: #f9f9f9;
    border: 1px solid #ddd;
    border-radius: 8px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    padding: 1rem;
    width: 200px;
    text-align: center;
    transition: transform 0.2s, box-shadow 0.2s;
  }

  /* Hover effect for menu blocks */
  .menu-block:hover {
    transform: translateY(-5px);
    cursor: pointer;
    box-shadow: 0 6px 10px rgba(0, 0, 0, 0.15);
  }

  .is_disabled {
    opacity: 0.5;
    color: #555
  }

  .is_disabled:hover {
    cursor: not-allowed;
  }

  /* Media query for mobile mode */
  @media (max-width: 768px) {
    .menu-block {
      width: 200px; 
    }
  }

  /* Style the list inside the menu block */
  .menu-block ul {
    list-style: none;
    padding: 0;
    margin: 0.5rem 0 0;
  }

  .menu-block li {
    margin: 0.25rem 0;
    color: #555;
    cursor: pointer;
    transition: color 0.2s;
  }

  .menu-block li:hover {
    color: #007bff;
  }

  a {
    text-decoration: none;
    color: inherit;
  }
</style>
