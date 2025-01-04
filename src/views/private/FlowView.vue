<script setup lang="ts">

import { onMounted, ref } from 'vue';
import { supabase } from '../../lib/supabase'
import router from '@/router';
import { v4 as uuidv4 } from 'uuid';
import ProgressBar from '@/components/ProgressBar.vue';

// const items = ref([{label: 'test'}])
// Lifecycle hook

const progress = ref(0);
const flowId = router.currentRoute.value.params.id;

const flow = ref<Flow | null>(null);
interface UserProfile {
  organization_id: string;
  uploads?: {
    filename: string;
  };
  latest_upload_id?: number;
  // Add other properties as needed
}

const user = ref<UserProfile | null>(null)
interface Node {
  id: string;
  name: string;
  signedUrl?: string;
  latest_upload_id?: number;
  // Add other properties as needed
}

interface Flow {
  id: string;
  name: string;
  description: string;
  // Add other properties as needed
}

const nodes = ref<Node[]>([])

const getSignedUrl = async (filename: string) => {
  const { data } = await supabase.storage
  .from('uploads')
  .createSignedUrl(filename, 3600)

  return data?.signedUrl;
}

const fetchNodes = async () => { 
   const {
    data: { user: fetchedUser },
    error: authError,
  } = await supabase.auth.getUser();

  if (authError) {
    throw authError;
  }

  // Fetch the user's profile from the database
  const { data: profileData, error } = await supabase
    .from('profiles')
    .select('organization_id')
    .eq('id', fetchedUser?.id) // Match the user ID
    .single(); // Retrieve only one record

  if (error) {
    throw error;
  }

  user.value = profileData;

  // Download flow details
  const { data } = await supabase
    .from('flows')
    .select('*')
    .eq('id', flowId)
    .single()

  flow.value = data;
  console.info(data);

  // Download nodes
  const { data: nodesData } = await supabase
    .from('nodes')
    .select('*, uploads!latest_upload_id(*)')
    .eq('flow_id', flowId)
    .order('name', {ascending: true})
    nodes.value = await Promise.all(
      nodesData?.map(async (node) => {
        let signedUrl;
        if (node.latest_upload_id) { 
          console.info(node.uploads.filename)
          signedUrl = await getSignedUrl(node.uploads.filename);
        }  
        
        return { ...node, signedUrl };
      }) || []
    );

  const nodesWithUploads = nodes.value.filter(node => node.latest_upload_id);
  progress.value = nodesWithUploads.length / nodes.value.length * 100;
  // Download documents
  // let { data: uploadsData, error: uploadsError } = await supabase
  //   .from('uploads')
  //   .select('*, nodes!latest_upload_id(*, flows(*))')
  //   .eq('nodes.flows.id', flowId)

  // uploads.value = uploadsData || [];
}

onMounted(async () => {
 fetchNodes()
});

// 1. Upload file
// 2. Once we have the upload response, insert row into uploads table 
// 4. Get the resulting id and update the node with the new upload id
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
    const { data: uploadedFile, error } = await supabase
      .storage
      .from('uploads') // Replace with your bucket name
      .upload(`${user.value?.organization_id}/${fileNameWithExtension}`, file, {
        contentType: mimeType, // Set the MIME type explicitly
      }); // Replace `folder-name/` with the desired folder

    if (error) {
      throw error;
    }

    // Insert a new upload line
    const { data: insertUploads } = await supabase
    .from('uploads')
    .insert([
      {
        filename: uploadedFile.path,
        node_id: Number(nodeId)
      },
    ])
      .select()

    if (!insertUploads) {
      throw new Error('Failed to insert upload');
    }

    const createdUpload = insertUploads[0];
    const { data: updatedNode } = await supabase
      .from('nodes')
      .update({ latest_upload_id: createdUpload.id })
      .eq('id', nodeId)
      .select()
              
    console.info(updatedNode)
    fetchNodes()
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
  <h3 v-if="flow">{{ flow.name }}</h3>
  <ProgressBar :value="progress" color="#2196f3" />

  <br/>
  <div class="card-container">
    <div class="card" v-for="node in nodes" :key="node.id">
      <div class="card-header">
        <h4>{{ node.name }}</h4>
      </div>
      <div class="card-body">
        <a v-if="node.signedUrl" target="_blank" :href="node.signedUrl" class="card-link">
          Open Document
        </a>
        <div class="file-input">
          <input type="file" :id="node.id" />
          <button @click="uploadFile(node.id)">Upload</button>
        </div>
      </div>
    </div>
  </div>
</template>



<style scoped>
.card-container {
  display: flex;
  flex-wrap: wrap;
  gap: 16px;
}

.card {
  width: 300px;
  border: 1px solid #ddd;
  border-radius: 8px;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
  overflow: hidden;
  background: #fff;
  display: flex;
  flex-direction: column;
  padding: 16px;
}

.card-header {
  font-size: 1.2rem;
  font-weight: bold;
  margin-bottom: 8px;
}

.card-body {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.card-link {
  color: #2196f3;
  text-decoration: none;
  font-weight: 500;
}

.card-link:hover {
  text-decoration: underline;
}

.file-input {
  display: flex;
  flex-direction: column; /* Stacks the file input and button vertically */
  gap: 8px; /* Adds spacing between them */
}

input[type="file"] {
  font-size: 0.9rem;
  padding: 4px;
}

button {
  padding: 8px 16px;
  background-color: #4caf50;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

button:hover {
  background-color: #45a049;
}
</style>
