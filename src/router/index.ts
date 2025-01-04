import { createRouter, createWebHistory } from 'vue-router'
import FlowsView from '@/views/private/FlowsView.vue'
import Flowview from '@/views/private/FlowView.vue'
import LoginView from '@/views/LoginView.vue'
import ContactView from '@/views/private/ContactView.vue'
import NewApplication from '@/views/private/NewApplication.vue'
import SignupView from '@/views/SignupView.vue'
import SettingsVue from '@/views/private/SettingsVue.vue'
import { supabase } from '../lib/supabase'
import Main from '@/components/Main.vue'
import ConfirmationView from '@/views/ConfirmationView.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/dashboard',
      name: 'dashboard',
      component: Main,
      meta: { requiresAuth: true },
      children: [
        {
          path: 'new-application',
          name: 'new-application',
          component: NewApplication,
        },    
        {
          path: 'settings',
          name: 'settings',
          component: SettingsVue, 
        },
        {
          path: 'contact',
          name: 'contact',
          component: ContactView,
        },
        {
          path: 'flows',
          name: 'flows',
          component: FlowsView,
        },
        {
          path: 'flow/:id',
          name: 'flow',
          component: Flowview,
        },
        {
          path: 'upload/:id',
          name: 'upload',
          component: Flowview,
        },
      ],
    },
    {
      path: '/login',
      name: 'login',
      component: LoginView,
      meta: {
        requiresAuth: false,
      }
    },
    {
      path: '/confirmation',
      name: 'confirmation',
      component: ConfirmationView,
      meta: {
        requiresAuth: false,
      }
    },
    {
      path: '/signup',
      name: 'signup',
      component: SignupView,
      meta: {
        requiresAuth: false,
      }
    },
     {
      path: '/:pathMatch(.*)*', // Wildcard route to catch all undefined routes
      redirect: '/dashboard/flows', // Redirect to the default path if the route is not found
    },
  ],
});

router.beforeEach(async (to, from, next) => {
  const { data } = await supabase.auth.getSession();

  // If the route requires authentication and the user is not logged in,
  if (to.meta.requiresAuth && !data.session) {
    next('/login');
  } else {
    console.info(to)
    next();
  }
});


export default router
