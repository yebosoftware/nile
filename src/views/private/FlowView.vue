<script setup lang="ts">

import { onMounted, ref } from 'vue';
import { supabase } from '../../lib/supabase'
import router from '@/router';
import { v4 as uuidv4 } from 'uuid';

// const items = ref([{label: 'test'}])
// Lifecycle hook

const flowId = router.currentRoute.value.params.id;
console.info(flowId)
const flow = ref<Flow | null>(null);
interface Node {
  id: string;
  name: string;
  // Add other properties as needed
}

interface Flow {
  id: string;
  name: string;
  description: string;
  // Add other properties as needed
}

const nodes = ref<Node[]>([])

onMounted(async () => {
  // Download flow details
  const { data } = await supabase
    .from('flows')
    .select('*')
    .eq('id', flowId)
    .single()

  flow.value = data;
  console.info(data);

  // Download nodes
  const { data: nodesData, error: nodesError } = await supabase
    .from('nodes')
    .select('*')
    .eq('flow_id', flowId)
  nodes.value = nodesData || [];
  console.info(nodesData, nodesError)
  // Download documents
  // let { data: uploadsData, error: uploadsError } = await supabase
  //   .from('uploads')
  //   .select('*, nodes!latest_upload_id(*, flows(*))')
  //   .eq('nodes.flows.id', flowId)

  // uploads.value = uploadsData || [];
});

const uploadFile = async (nodeId: string) => {
  const newUUID = uuidv4(); // Generate a unique ID
  const fileInput = document.getElementById(nodeId);
  if (!fileInput) {
    console.error('File input element not found');
    return;
  }
  const file = (fileInput as HTMLInputElement).files?.[0];

  if (!file) {
    console.error('No file selected');
    return;
  }

  const fileExtension = file.name.split('.').pop();
  const mimeType = file.type; // Get the MIME type from the file

  const fileNameWithExtension = `${newUUID}.${fileExtension}`; // Create the f
  try {
    // Upload the file to the Supabase storage bucket
    const { data, error } = await supabase
      .storage
      .from('uploads') // Replace with your bucket name
      .upload(fileNameWithExtension, file, {
        contentType: mimeType, // Set the MIME type explicitly
      }); // Replace `folder-name/` with the desired folder

    if (error) {
      throw error;
    }

    console.log('File uploaded successfully:', data);
  } catch (error) {
    console.error('Error uploading file:', error);
  }
};
// const downloadFile = async (id) => {
//   const { data, error } = await supabase
//       .storage
//       .from(bucketName)
//       .download(filePath);
// }
</script>

<template>
  <h3 v-if="flow">{{flow.name}}</h3>
  <h6 v-if="flow">{{flow.description}}</h6>
  <div>Documents</div>
  <ul>
    <li v-for="node in nodes" :key="node.id">
      <a target="_blank">
        {{ node.name }}
      </a>
      <!-- <button @click="downloadFile(upload.id)">Download</button> -->
      <button @click="uploadFile(node.id)">Upload new</button>
      <input type="file" :id="node.id" />
    </li>
  </ul>
  <!-- <ul>
    <li v-for="upload in uploads" :key="upload.id">
      <button @click="downloadFile(upload.id)">Download</button>
      <button @click="uploadFile">Upload new</button>
      <input type="file" id="fileInput" />
      <a target="_blank" href="https://qldtvnlmytnpjouadman.supabase.co/storage/v1/object/public/uploads/photo_2025-01-03%2010.21.39.jpeg">
        {{ upload.nodes[0].name }}
      </a>
    </li>
  </ul> -->
</template>

<style scoped>

</style>
