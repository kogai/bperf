import React from "react";
import { render } from "react-dom";
import { BrowserRouter as Router, Route } from "react-router-dom";
import { Dashboard } from "./containers/Dashboard";

const root = document.querySelector("#root");

if (!root) {
  throw new Error("Entry point of the application not found.");
}

render(
  <Router>
    <Route path="/" exact component={Dashboard} />
  </Router>,
  root
);
