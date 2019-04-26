import React, { ComponentType } from "react";
import { Link } from "react-router-dom";
import { Bar } from "react-chartjs-2";
import { pipe, groupBy, toPairs, map } from "ramda";
import styled, { StyledComponent } from "styled-components";
import { Event } from "../../modules/http";

const data = {
  labels: ["January", "February", "March", "April", "May", "June", "July"],
  datasets: [
    {
      label: "My First dataset",
      fillColor: "rgba(220,220,220,0.5)",
      strokeColor: "rgba(220,220,220,0.8)",
      highlightFill: "rgba(220,220,220,0.75)",
      highlightStroke: "rgba(220,220,220,1)",
      data: [65, 59, 80, 81, 56, 55, 40]
    },
    {
      label: "My Second dataset",
      fillColor: "rgba(151,187,205,0.5)",
      strokeColor: "rgba(151,187,205,0.8)",
      highlightFill: "rgba(151,187,205,0.75)",
      highlightStroke: "rgba(151,187,205,1)",
      data: [28, 48, 40, 19, 86, 27, 90]
    }
  ]
};

export type Props = { events: Event[]; onClick: () => void };

export const Dashboard: ComponentType<Props> = ({ events, onClick }) => {
  console.log(
    pipe(
      (xs: Event[]) => xs.filter(x => x.eventType === "childList"),
      (xs: Event[]) => xs.map(x => x.time)
      // groupBy<Event>(({ eventType }) => eventType)
      // toPairs,
      // map(([key, beacons]) => {

      // })
    )(events)
  );
  return (
    <>
      <Bar
        data={{
          labels: [
            "January",
            "February",
            "March",
            "April",
            "May",
            "June",
            "July"
          ],
          datasets: [
            {
              label: "My Second dataset",
              // fillColor: "rgba(151,187,205,0.5)",
              // strokeColor: "rgba(151,187,205,0.8)",
              // highlightFill: "rgba(151,187,205,0.75)",
              // highlightStroke: "rgba(151,187,205,1)",
              data: [28, 48, 40, 19, 86, 27, 90]
            }
          ]
        }}
      />
      <table>
        <tbody>
          <tr>
            <th>event type</th>
            <th>time</th>
          </tr>
          {events.map(({ time, eventType }, i) => (
            <tr key={i}>
              <td>{eventType}</td>
              <td>{time}</td>
            </tr>
          ))}
        </tbody>
      </table>
      <button type="button" onClick={onClick}>
        update
      </button>
    </>
  );
};
