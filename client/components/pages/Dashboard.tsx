import React, { ComponentType } from "react";
import { Link } from "react-router-dom";
import styled, { StyledComponent } from "styled-components";
import { Event } from "../../modules/http";

export type Props = { events: Event[]; onClick: () => void };

export const Dashboard: ComponentType<Props> = ({ events, onClick }) => (
  <>
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
