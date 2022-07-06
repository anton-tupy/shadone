import Vue from 'vue'
import App from './user-show.vue'

document.addEventListener('turbolinks:load', () => {
  const selector = '#js-user-show'
  const userShow = document.querySelector(selector)
  if (userShow) {
    new Vue({ render: (h) => h(App) }).$mount(selector)
  }
})
