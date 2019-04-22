import React, { ComponentType } from "react";
import { Link } from "react-router-dom";
import styled, { StyledComponent } from "styled-components";
import { Event } from "../../modules/http";

export type Props = { events: Event[]; onClick: () => void };

export const Dashboard: ComponentType<Props> = ({ events, onClick }) => (
  <>
    <table>
      {events.map(({ time, eventType }, i) => (
        <tr key={i}>
          <th>event type</th>
          <td>{eventType}</td>
          <th>time</th>
          <td>{time}</td>
        </tr>
      ))}
    </table>
    <button type="button" onClick={onClick}>
      update
    </button>
  </>
);
