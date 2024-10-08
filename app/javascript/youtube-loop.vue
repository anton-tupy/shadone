<template>
  <div id="youtubeloop" class="sha-youtube flex flex-col sm:flex-row gap-6">
    <div class="sha-youtube__container">
      <youtube
        ref="youtube"
        :video-id="videoId"
        :player-vars="playerVars"
      ></youtube>
    </div>

    <div class="sha-youtube__form grow max-w-md">
      <div class="flex items-center">
        <div class="w-24 hidden sm:block">
          <label class="text-sm font-semibold">URL</label>
        </div>
        <div class="flex-1">
          <input
            id="url"
            v-model="url"
            type="url"
            class="input input-bordered input-secondary w-full"
            placeholder="https://www.youtube.com/watch?v=a-kWmI-RBUQ"
          />
        </div>
      </div>

      <div class="flex items-center mt-1">
        <div class="w-24 hidden sm:block"></div>
        <div class="flex-1">
          <div class="text-xs text-gray">Paste your favorite YouTube URL</div>
        </div>
      </div>

      <div class="flex items-center mt-4">
        <div class="w-24">
          <label class="text-sm font-semibold">Start From</label>
        </div>
        <div class="flex-1">
          <input
            id="start-minute"
            v-model.number="startMinute"
            type="number"
            min="0"
            max="59"
            class="input input-bordered input-secondary w-full"
            placeholder="0"
          />
        </div>
        <div class="w-4">
          <div class="text-center">:</div>
        </div>
        <div class="flex-1">
          <input
            id="start-second"
            v-model.number="startSecond"
            type="number"
            min="0"
            max="59"
            class="input input-bordered input-secondary w-full"
            placeholder="55"
          />
        </div>
      </div>

      <div class="flex items-center mt-1">
        <div class="w-24 hidden sm:block"></div>
        <div class="flex-1">
          <div class="text-xs text-gray">Set the video start time</div>
        </div>
      </div>

      <div class="flex items-center mt-4">
        <div class="w-24">
          <label class="text-sm font-semibold">End At</label>
        </div>
        <div class="flex-1">
          <input
            id="end-minute"
            v-model.number="endMinute"
            type="number"
            min="0"
            max="59"
            class="input input-bordered input-secondary w-full"
            placeholder="1"
          />
        </div>
        <div class="w-4">
          <div class="text-center">:</div>
        </div>
        <div class="flex-1">
          <input
            id="end-second"
            v-model.number="endSecond"
            type="number"
            min="0"
            max="59"
            class="input input-bordered input-secondary w-full"
            placeholder="22"
          />
        </div>
      </div>

      <div class="flex items-center mt-1">
        <div class="w-24 hidden sm:block"></div>
        <div class="flex-1">
          <div class="text-xs text-gray">Set the video end time</div>
        </div>
      </div>

      <div class="flex items-center mt-4">
        <div class="w-24">
          <label class="text-sm font-semibold">Loop Count</label>
        </div>
        <div class="flex-1">
          <input
            id="loop-count"
            v-model.number="loopCount"
            type="number"
            min="1"
            placeholder="3"
            class="input input-bordered input-secondary w-full"
          />
        </div>
      </div>

      <div class="flex items-center mt-1">
        <div class="w-24 hidden sm:block"></div>
        <div class="flex-1">
          <div class="text-xs text-gray">
            Set how many times you want to loop the video
          </div>
        </div>
      </div>

      <div class="flex items-center mt-4">
        <div class="w-24">
          <label class="text-sm font-semibold">Speed</label>
        </div>
        <div class="flex-1">
          <select
            v-model="playbackSpeed"
            class="select select-bordered select-secondary w-full"
          >
            <option
              v-for="item in selectItems"
              :key="item.id"
              :value="item.speed"
            >
              {{ item.speed }}
            </option>
          </select>
        </div>
      </div>

      <div class="flex items-center mt-1">
        <div class="w-24 hidden sm:block"></div>
        <div class="flex-1">
          <div class="text-xs text-gray">
            Select playback speed of the video
          </div>
        </div>
      </div>

      <div class="flex gap-5 mt-4 justify-center sm:justify-start">
        <div class="flex items-center">
          <button
            v-if="!playing"
            class="py-3 px-4 w-40 bg-success font-semibold rounded-lg sha-icon focus:outline-none focus:ring-2 focus:ring-blue-400 focus:ring-opacity-75"
            @click="startLoop"
          >
            Start
          </button>
          <button
            v-else
            class="py-3 px-4 w-40 bg-success font-semibold rounded-lg sha-icon focus:outline-none focus:ring-2 focus:ring-blue-400 focus:ring-opacity-75"
            @click="endLoop"
          >
            Quit
          </button>
        </div>

        <div
          v-if="playing"
          class="sha-count flex justify-center items-center border rounded-lg px-3"
        >
          <p>{{ remainingLoopCount }}</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import Vue from 'vue'
import VueYoutube from 'vue-youtube'
import getYouTubeId from 'get-youtube-id'
import VueToast from 'vue-toast-notification'
import 'vue-toast-notification/dist/theme-sugar.css'
import YouTubeSizeChangable from './mixins/youtube-size-changable.js'

Vue.use(VueYoutube)
Vue.use(VueToast)

export default {
  mixins: [YouTubeSizeChangable],
  props: {
    notice: { type: String, default: null, required: false },
  },
  data() {
    return {
      playerVars: {
        rel: 0,
      },
      url: 'https://www.youtube.com/watch?v=a-kWmI-RBUQ',
      playing: false,
      startMinute: 0,
      startSecond: 55,
      endMinute: 1,
      endSecond: 20,
      loopCount: 3,
      remainingLoopCount: null,
      playbackSpeed: 1,
      selectItems: [
        { id: 1, speed: 0.5 },
        { id: 2, speed: 0.75 },
        { id: 3, speed: 0.8 },
        { id: 4, speed: 0.85 },
        { id: 5, speed: 0.9 },
        { id: 6, speed: 0.95 },
        { id: 7, speed: 1 },
        { id: 8, speed: 1.25 },
        { id: 9, speed: 1.5 },
      ],
      intervalId: null,
    }
  },
  computed: {
    player() {
      return this.$refs.youtube.player
    },
    practiceDuration() {
      return (
        ((this.endTime - this.startTime) *
          (this.loopCount - this.remainingLoopCount)) /
        this.playbackSpeed
      )
    },
    startTime() {
      return this.startMinute * 60 + this.startSecond
    },
    endTime() {
      return this.endMinute * 60 + this.endSecond
    },
    videoId() {
      return getYouTubeId(this.url)
    },
    durationOfOneLoop() {
      return ((this.endTime - this.startTime + 1) / this.playbackSpeed) * 1000
    },
  },
  watch: {
    url(newUrl) {
      localStorage.url = newUrl
    },
    startMinute(newStartMinute) {
      localStorage.startMinute = newStartMinute
    },
    startSecond(newStartSecond) {
      localStorage.startSecond = newStartSecond
    },
    endMinute(newEndMinute) {
      localStorage.endMinute = newEndMinute
    },
    endSecond(newEndSecond) {
      localStorage.endSecond = newEndSecond
    },
    playbackSpeed(newPlaybackSpeed) {
      localStorage.playbackSpeed = newPlaybackSpeed
    },
    loopCount(newLoopCount) {
      localStorage.loopCount = newLoopCount
    },
  },
  mounted() {
    this.displayNotice()
  },
  created() {
    if (localStorage.url) {
      this.url = localStorage.url
    }
    if (localStorage.startMinute) {
      this.startMinute = Number(localStorage.startMinute)
    }
    if (localStorage.startSecond) {
      this.startSecond = Number(localStorage.startSecond)
    }
    if (localStorage.endMinute) {
      this.endMinute = Number(localStorage.endMinute)
    }
    if (localStorage.endSecond) {
      this.endSecond = Number(localStorage.endSecond)
    }
    if (localStorage.playbackSpeed) {
      this.playbackSpeed = Number(localStorage.playbackSpeed)
    }
    if (localStorage.loopCount) {
      this.loopCount = Number(localStorage.loopCount)
    }
  },
  methods: {
    startLoop() {
      this.playing = true
      this.setPlaybackRate()
      this.remainingLoopCount = this.loopCount
      this.intervalId = this.setLoop()
    },
    endLoop() {
      clearInterval(this.intervalId)
      this.player.pauseVideo()
      this.playing = false
      this.createPracticeLog()
    },
    setPlaybackRate() {
      this.player.setPlaybackRate(this.playbackSpeed)
    },
    setLoop() {
      const eachLoop = () => {
        this.player.seekTo(this.startTime)
        this.player.playVideo()
      }
      eachLoop()
      return setInterval(() => {
        this.remainingLoopCount--
        if (this.remainingLoopCount === 0) {
          this.endLoop()
          return
        }
        eachLoop()
      }, this.durationOfOneLoop)
    },
    createPracticeLog() {
      const practiceLog = {
        url: this.url,
        duration: this.practiceDuration,
      }
      this.$emit('loop-done', practiceLog)
    },
    displayNotice() {
      if (this.notice) {
        this.$toast.success(this.notice, {
          position: 'top-left',
        })
      }
    },
  },
}
</script>
