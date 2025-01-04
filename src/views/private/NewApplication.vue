<script setup lang="ts">

import { onMounted, ref } from 'vue';
import { supabase } from '../../lib/supabase'
import router from '@/router';
// const items = ref([{label: 'test'}])
// Lifecycle hook
const name = ref('');
const createFlowAndNodes = async () => {
  console.log('Name submitted:', name.value);
  // Create a new flow using the flow template id;
  const {
      data: { user: fetchedUser },
      error: authError,
    } = await supabase.auth.getUser();

    if (authError) {
      throw authError;
    }

    const { data: profile, error } = await supabase
      .from('profiles')
      .select('organization_id')
      .eq('id', fetchedUser?.id) // Match the user ID
      .single(); // Retrieve only one record

    if (error) {
      throw error;
    }

  const { data } = await supabase
    .from('flows')
    .insert([
      {
        name: name.value,
        flow_template_id: router.currentRoute.value.query.flow_template_id,
        organization_id: profile.organization_id
      },
    ])
    .select()

  
  if (!data || data.length === 0) {
    console.error('No data returned from flow creation');
    return;
  }

  const nodesToBeCopied = nodeTemplates.value.map(template => ({
    name: template.name,
    flow_id: data[0].id,
    node_type_id: template.node_type_id,
  }))

  
  // const createdFlow = data[0];
  const { error: createNodesError  } = await supabase
    .from('nodes')
    .insert(nodesToBeCopied)
    .select()
  console.info(createNodesError)

  router.push({ name: 'flow', params: { id: data[0].id } });
};


// Fetch all node_templates by flow_template_id
const flowTemplateId = router.currentRoute.value.query.flow_template_id;
interface NodeTemplate {
  name: string;
  node_type_id: number;
}

const nodeTemplates = ref<NodeTemplate[]>([]);
const fetchNodeTemplates = async () => { 
  const { data: flowTemplateNodesData } = await supabase
    .from('node_templates')
    .select('*')
    .eq('flow_template_id', flowTemplateId)
  console.info(flowTemplateNodesData)
  nodeTemplates.value = flowTemplateNodesData || [];
}

onMounted(() => {
  fetchNodeTemplates();
});
</script>

<template>
  <h3>New Application - Company registration</h3>
  <div>
    <form @submit.prevent="createFlowAndNodes">
      
      <input
        type="text"
        id="name"
        v-model="name"
        placeholder="Enter the name of the company you want to register"
        required
      />
      <button type="submit">Submit</button>
    </form>

    <!-- Display the name entered by the user -->
    <div v-if="name">
      <p>Your name is: {{ name }}</p>
    </div>
  </div>
</template>

<style scoped>
  label {
    display: block;
    margin-bottom: 8px;
    font-size: 16px;
  }

  input {
    width: 100%;
    padding: 8px;
    margin-bottom: 12px;
    border: 1px solid #ccc;
    border-radius: 4px;
  }

  button {
    width: 100%;
    padding: 10px;
    background-color: #13253f;
    color: white;
    border: none;
    border-radius: 4px;
    cursor: pointer;
  }

  button:hover {
    background-color: #105a80;
  }
</style>
