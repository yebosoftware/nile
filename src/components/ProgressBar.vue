<template>
   <div class="progress-bar-container">
    <div
      class="progress-bar"
      :style="{ width: computedWidth, backgroundColor: color }"
    >
    <span class="progress-text">{{ value }}%</span>
  </div>
    
  </div>
</template>

<script setup lang="ts">
import { computed, defineProps } from 'vue';


// Define props for the ProgressBar component
const props = defineProps({
  value: {
    type: Number,
    required: true,
    validator: (v: number) => v >= 0 && v <= 100, // Ensure value is between 0 and 100
  },
  color: {
    type: String,
    default: '#13253f', // Default green color
  },
});

// Compute the width of the progress bar
const computedWidth = computed(() => `${props.value}%`);
</script>

<style scoped>
  .progress-bar-container {
    width: 100%;
    height: 20px;
    background-color: #e0e0e0;
    border-radius: 10px;
    overflow: hidden;
  }

  .progress-bar {
    height: 100%;
    transition: width 0.3s ease;
  }

  .progress-text {
    width: 100%;
    font-size: 14px;
    color: #000;
    top: 0;
    left: 0;
    line-height: 20px;
  }
</style>
