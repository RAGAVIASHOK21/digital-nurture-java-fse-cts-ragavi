console.log("Welcome to the Community Portal");

window.onload = function () {

    alert("Page Loaded Successfully");

};
const eventName = "Music Festival";
const eventDate = "10 June 2026";

let seats = 50;
console.log(`${eventName} on ${eventDate}`);
seats--;

function validatePhone() {

    let phone =
        document.getElementById("phone").value;

    if (phone.length < 10) {

        alert("Enter valid phone number");

    }
}

function showFee() {

    let eventType =
        document.getElementById("eventType").value;

    let fee =
        document.getElementById("fee");

    if (eventType === "Music") {

        fee.innerHTML = "Fee: ₹500";

    }

    else if (eventType === "Sports") {

        fee.innerHTML = "Fee: ₹300";

    }

    else if (eventType === "Workshop") {

        fee.innerHTML = "Fee: ₹700";

    }

    else {

        fee.innerHTML = "";

    }
}

function showConfirmation() {

    document.getElementById("outputMessage")
        .innerHTML = "Registration Successful!";
}

function enlargeImage(image) {

    image.style.width = "350px";
    image.style.height = "250px";
}

function countCharacters() {

    let text =
        document.getElementById("feedback").value;

    document.getElementById("charCount")
        .innerHTML = text.length;
}

function videoReady() {

    document.getElementById("videoMessage")
        .innerHTML = "Video ready to play";
}

window.onbeforeunload = function () {

    return "Your form is not submitted!";
};

let eventSelect =
    document.getElementById("eventType");

eventSelect.addEventListener("change", function () {

    localStorage.setItem(
        "preferredEvent",
        eventSelect.value
    );

});

window.addEventListener("load", function () {

    let savedEvent =
        localStorage.getItem("preferredEvent");

    if (savedEvent) {

        eventSelect.value = savedEvent;

    }

});

function findLocation() {

    if (navigator.geolocation) {

        navigator.geolocation.getCurrentPosition(

            showPosition,
            showError,

            {
                enableHighAccuracy: true,
                timeout: 10000,
                maximumAge: 0
            }

        );

    }

    else {

        alert("Geolocation is not supported by this browser.");

    }
}

function showPosition(position) {

    document.getElementById("location").innerHTML =

        "Latitude: " +
        position.coords.latitude +

        "<br>Longitude: " +
        position.coords.longitude;
}

function showError(error) {

    switch (error.code) {

        case error.PERMISSION_DENIED:

            alert("Location access denied by user.");
            break;

        case error.POSITION_UNAVAILABLE:

            alert("Location information unavailable.");
            break;

        case error.TIMEOUT:

            alert("Location request timed out.");
            break;

        case error.UNKNOWN_ERROR:

            alert("An unknown error occurred.");
            break;
    }
}

let events = [

    "Music Festival",
    "Sports Meet",
    "Baking Workshop"

];

events.push("Dance Show");

let musicEvents =
    events.filter(event =>
        event.includes("Music")
    );

console.log(musicEvents);

let formattedEvents =
    events.map(event =>
        `Workshop on ${event}`
    );

console.log(formattedEvents);

document.getElementById("registrationForm")
    .addEventListener("submit", function (event) {

        event.preventDefault();

        let name =
            document.getElementById("name").value;

        let email =
            document.getElementById("email").value;

        if (name === "" || email === "") {

            alert("Fill all fields");

        }

        else {

            alert("Form Submitted Successfully");

        }

    });

async function fetchEvents() {

    try {

        let response =
            await fetch(
                "https://jsonplaceholder.typicode.com/posts"
            );

        let data =
            await response.json();

        console.log(data);

    }

    catch (error) {

        console.log(error);

    }
}

fetchEvents();