<template>
  <div class="search-container">
    <h1 class="title">{{ hasSearched ? "Search Results" : "Looking for an employee?" }}</h1>
    <p v-if="!hasSearched" class="subtitle">Click on the search bar to learn our suggestions</p>

    <div class="input-group" ref="autocompleteWrapper">
      <div class="search-box">
        <input
          type="text"
          v-model="query"
          @input="handleInput"
          @focus="handleFocus"
          placeholder="Search..."
        />
        <button @click="handleSearch" class="search-button">🔍</button>
      </div>

      <!-- Suggestions Dropdown -->
      <div v-show="showDropdown && suggestions.length" class="suggestions-container">
        <ul class="suggestions">
          <li v-for="item in suggestions" :key="item.name" @click="selectItem(item)" class="suggestion-item">
            <img :src="getImage(item.imageUrl)" @error="setDefaultImage($event)" alt="" class="thumbnail" />
            <div class="suggestion-info">
              <strong class="name">{{ item.name }}</strong>
              <p class="job-title">{{ item.description }}</p>
            </div>
          </li>
        </ul>
      </div>
    </div>

    <!-- Search Results -->
    <div class="results-container" v-if="searchResults.length">
      <ul class="results-list">
        <li v-for="item in searchResults" :key="item.name" class="result-item">
          <img :src="getImage(item.imageUrl)" @error="setDefaultImage($event)" alt="" class="thumbnail" />
          <div class="result-info">
            <strong class="name">{{ item.name }}</strong>
            <p class="job-title">{{ item.description }}</p>
          </div>
        </li>
      </ul>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import _ from 'lodash';

export default {
  data() {
    return {
      query: '',
      suggestions: [],
      searchResults: [],
      showDropdown: false,
      hasSearched: false, 
      apiUrl: "http://localhost:8000/search",
      defaultImage: "https://www.w3schools.com/howto/img_avatar.png",
      debouncedFetchSuggestions: null
    };
  },

  created() {
    this.debouncedFetchSuggestions = _.debounce(this.fetchSuggestions, 300);
  },

  mounted() {
    document.addEventListener("click", this.handleClickOutside);
  },

  beforeUnmount() {
    document.removeEventListener("click", this.handleClickOutside);
  },

  methods: {
    handleInput() {
      if (this.query.length >= 2) {
        this.showDropdown = true;
        this.debouncedFetchSuggestions();
      } else {
        this.showDropdown = false;
        this.suggestions = [];
      }
    },

    handleFocus() {
      this.showDropdown = true;
      if (this.query.length >= 2) {
        this.debouncedFetchSuggestions();
      }
    },

    async fetchSuggestions() {
      try {
        const response = await axios.get(`${this.apiUrl}`, {
          params: { q: this.query, entity: 'users' }
        });

        this.suggestions = response.data.map(item => ({
          ...item,
          checkedImageUrl: this.getImage(item.imageUrl)
        }));
      } catch (error) {
        console.error('Error fetching suggestions:', error);
      }
    },

    async handleSearch() {
      if (!this.query.trim()) return;
      this.hasSearched = true; 
      this.showDropdown = false;
      this.suggestions = [];

      try {
        const response = await axios.get(`${this.apiUrl}`, {
          params: { q: this.query, entity: 'users' }
        });

        this.searchResults = response.data.map(item => ({
          ...item,
          checkedImageUrl: this.getImage(item.imageUrl)
        }));
      } catch (error) {
        console.error('Error fetching search results:', error);
      }
    },

    selectItem(item) {
      this.query = item.name;
      this.hasSearched = true;
      this.showDropdown = false;
    },

    getImage(imageUrl) {
      return imageUrl && imageUrl.trim() !== "" ? imageUrl : this.defaultImage;
    },

    setDefaultImage(event) {
      event.target.src = this.defaultImage;
    },

    handleClickOutside(event) {
      if (this.$refs.autocompleteWrapper && !this.$refs.autocompleteWrapper.contains(event.target)) {
        this.showDropdown = false;
      }
    }
  }
};
</script>

<style>
body {
  background-image: url('../images/bg.png');
}

.search-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 20px;
  width: 100%;
  min-height: 100vh;
  color: white;
}

.input-group {
  display: flex;
  flex-direction: column;
  align-items: center;
  width: 50%;
  position: relative;
}

.search-box {
  display: flex;
  align-items: center;
  width: 96%;
  background: white;
  border-radius: 25px;
  padding: 5px 15px;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
  z-index: 5;
}

input {
  padding: 12px;
  border: none;
  border-radius: 20px;
  font-size: 16px;
  flex-grow: 1;
  outline: none;
}

.search-button {
  padding: 0.5rem;
  border: none;
  background-color: #254be4;
  color: white;
  border-radius: 50px;
  cursor: pointer;
  font-size: 16px;
  transition: all 0.3s ease;
}

.search-button:hover {
  background-color: #00ade6;
}

.suggestions-container {
  width: 100%;
  background: white;
  border-radius: 10px;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
  position: absolute;
  padding-top: 3rem;
  margin: 0;
  top: 0.7rem;
  left: 0;
  z-index: 1;
  max-height: 200px;
  overflow-y: auto;
}

.suggestions {
  list-style: none;
  padding: 0;
  margin: 0;
}

.suggestion-item {
  display: flex;
  align-items: center;
  padding: 15px;
  border-bottom: 1px solid #eee;
  cursor: pointer;
  transition: background 0.3s ease;
}

.suggestion-item:hover {
  background: #f0f0f0;
}

.thumbnail {
  width: 50px;
  height: 50px;
  border-radius: 50%;
  margin-right: 15px;
  object-fit: cover;
}

.name {
  font-size: 16px;
  font-weight: bold;
  color: #333;
}

.job-title {
  font-size: 14px;
  color: gray;
}

.results-container {
  margin-top: 20px;
  width: 80%;
  background: rgba(255, 255, 255, 0.3);
  padding: 20px;
  border-radius: 15px;
}
</style>
