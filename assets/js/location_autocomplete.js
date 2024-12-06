
document.addEventListener("DOMContentLoaded", function () {
  const locationInput = document.getElementById("location");
  const suggestionsList = document.getElementById("suggestions-list");

  if (locationInput) {
    locationInput.addEventListener("input", async function (e) {
      const query = e.target.value;
      const response = await fetch(`https://nominatim.openstreetmap.org/search?q=${query}&format=json`);
      const data = await response.json();

      // Clear any previous suggestions
      suggestionsList.innerHTML = '';

      // Show the suggestions dropdown if there are results
      if (data.length > 0) {
        suggestionsList.classList.remove('hidden'); // Show the dropdown

        data.forEach(location => {
          const listItem = document.createElement('li');
          listItem.classList.add('p-2', 'cursor-pointer', 'hover:bg-gray-100');
          listItem.textContent = location.display_name;
          
          listItem.addEventListener('click', function () {
            locationInput.value = location.display_name;  // Fill input with the selected location
            suggestionsList.classList.add('hidden');  // Hide the suggestions list after selection
          });

          suggestionsList.appendChild(listItem);
        });
      } else {
        suggestionsList.classList.add('hidden');  // Hide dropdown if no results
      }
    });

    // Hide the dropdown if input is cleared
    locationInput.addEventListener("blur", function () {
      setTimeout(() => {
        suggestionsList.classList.add('hidden');
      }, 200); // Delay hiding to allow for clicks on suggestions
    });

    locationInput.addEventListener("focus", function () {
      if (locationInput.value !== '') {
        suggestionsList.classList.remove('hidden'); // Show the dropdown when the input is focused
      }
    });
  }
});








