<!DOCTYPE html>
<html>

<head>
  <title>Irrigator Irrigation System</title>
  <style>
    .banner {
      background: #AAAAAA;
    }

    .water-switch-container {
      width: 450px;
      height: 50px;
      display: flex;
      flex-direction: row;
      justify-content: space-around;
    }

    .loader {
      margin: 5px;
      border: 5px solid #AAAAAA;
      border-top: 5px solid #000000;
      border-radius: 50%;
      width: 20px;
      height: 20px;
      animation: spin 2s linear infinite;
    }

    @keyframes spin {
      0% {
        transform: rotate(0deg);
      }

      100% {
        transform: rotate(360deg);
      }
    }
    
    #errorOutput {
      width: 100%;
      height: 50px;
    }
  </style>
</head>

<body>
  <div class="banner">
    <h1>Irrigator Irrigation System</h1>
  </div>
  <div style="display: flex; flex-direction: row; justify-content: space-around;">
    <div class="iot-data">
      <h2>Current Soil Moisture</h2>
      <iframe width="450" height="260" "
      src="
        https://thingspeak.com/channels/2667716/charts/1?bgcolor=%23ffffff&color=%23d62020&days=14&dynamic=true&results=100&type=line&xaxis=Time&yaxis=Moisture"></iframe>
      <div class="water-switch-container">
        <div>
          <p>Watering Status: </p>
          <b>
            <p id="watering-status"></p>
          </b>
          <div class="loader" id="water-switch-loader"></div>
        </div>
        <button id="water-switch"></button>
      </div>
    </div>
    <div>
      <h1>State Machine Configuration</h1>
      <iframe id="errorOutput" name="errorOutput" frameBorder="0"> </iframe>
      <div>
        <p>Current Maximum: </p>
        <b>
          <p id="current-max"></p>
        </b>
        <p>Current Minimum: </p>
        <b>
          <p id="current-min"></p>
        </b>
      </div>
      <h2>Edit State Machine Values</h2>
      <form method="post" action="updatebounds.php" accept-charset="utf-8" target="errorOutput" onsubmit="fetchCurrentSMBounds();">
        State Machine Maximum: <input type="text" name="upperBound"><br>
        State Machine Minimum: <input type="text" name="lowerBound"><br>
        <input type="submit" value="Apply">
      </form>  	
    </div>
  </div>
</body>

<script>
  document.addEventListener("DOMContentLoaded", function () {
    valsOnPageLoad();
    fetchWateringStatus().then(function (response) {
      setValsOnRequest(response);
    });
    fetchCurrentSMBounds();
  });

  document.getElementById("water-switch").onclick = function () { fetchSwitchWatering() };

  function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
  }
  
  function fetchCurrentSMBounds() {
  	var currMax = document.getElementById("current-max");
  	var currMin = document.getElementById("current-min");
  	fetch("fetchbounds.php", {
      method: "POST",
      headers: {
        "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
      },
      body: "",
    })
      .then((response) => {
        try {
          JSON.parse(response);
        } catch (error) {
        console.log(error);
        currMax.innerText = "ERROR: Unable to retreive current SM Configuration.";
        currMin.innerText = "ERROR: Unable to retreive current SM Configuration.";
        }
        return response.json();
      })
      .then((response) => {
        currMax.innerText = response.upperBound;
        currMin.innerText = response.lowerBound;
      });
  }

  async function fetchWateringStatus() {
    var response = await fetch("https://api.thingspeak.com/channels/2756308/fields/1.json?results=1");
    var responseJson = await response.json();
    var feedsArray = responseJson.feeds[responseJson.feeds.length - 1];
    var state = parseInt(feedsArray["field1"]);
    if (state == NaN) {
      alert("Error: Could not fetch irrigation state.")
      return -1;
    }
    return state;
  }

  function setWateringButtonText(status) {
    if (status > 0) {
      document.getElementById("water-switch").innerHTML = "Stop Watering";
    } else {
      document.getElementById("water-switch").innerHTML = "Start Watering";
    }
  }

  function setWateringButtonTextLoading(status) {
    if (status > 0) {
      document.getElementById("water-switch").innerHTML = "Starting water cycle...";
    } else {
      document.getElementById("water-switch").innerHTML = "Stopping water cycle...";
    }
  }

  function setWateringSwitchLoadingView(visibility) {
    console.log(document.getElementById("water-switch-loader"));
    if (visibility == true) {
      document.getElementById("water-switch-loader").style.visibility = 'visible';
    } else {
      document.getElementById("water-switch-loader").style.visibility = 'hidden';
    }
  }

  function setWateringStatus(status) {
    if (status > 0) {
      document.getElementById("watering-status").innerHTML = "On";
    } else {
      document.getElementById("watering-status").innerHTML = "Off";
    }
  }

  function valsOnPageLoad() {
    document.getElementById("water-switch").innerHTML = "Loading...";
    setWateringSwitchLoadingView(true);
  }

  function setValsOnRequest(status) {
    setWateringSwitchLoadingView(false);
    setWateringStatus(status);
    setWateringButtonText(status);
  }

  function setValsOnLoading(status) {
    setWateringButtonTextLoading(status);
    document.getElementById("watering-status").innerHTML = "";
    setWateringSwitchLoadingView(true);
  }

  async function waitForWaterStatusChange(new_state) {
    // We can only write every 15 seconds, so the delay for check is 17 seconds initally
    // and then 5 seconds on retry
    timeout_max_retries = 3;
    timeout_time_per_retry = 5000;

    await sleep(10000)
    var status;
    for (let i = 0; i < timeout_max_retries; i++) {
      status = await fetchWateringStatus();
      if (status == new_state) {
        setWateringButtonText(status);
        return true;
      }
      await sleep(5000)
    }
    setValsOnRequest(status);
    alert("Error: Watering status could not be updated.")
  }


  async function fetchSwitchWatering() {
    var status = await fetchWateringStatus();
    let new_state = 0;
    if (status == 0) {
      new_state = 1;
    }
    fetch("updatewaterswitch.php", {
      method: "POST",
      headers: {
        "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
      },
      body: `watering=${new_state}`,
    })
      .then((response) => {
        try {
          JSON.parse(response);
        } catch (error) {
          console.log(response);
        }
        return response.json();
      })
      .then((res) => {
        if (res > 0) {
          alert(`Error: ${res}`)
        }
        else {
          setValsOnLoading(new_state);
          waitForWaterStatusChange(new_state);
        }
      });
  }

</script>

</html>
