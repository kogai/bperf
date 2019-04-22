import React, { useState, useEffect, ComponentType } from "react";
import { getEvents, Event } from "../modules/http";
import { Dashboard as Page } from "../components/pages/Dashboard";

export type Props = {};

export const Dashboard: ComponentType<Props> = params => {
  const [events, setEvents] = useState<Event[]>([]);
  useEffect(() => {
    getEvents().then(xs => {
      setEvents(xs);
    });
  }, []);

  return (
    <Page
      events={events}
      onClick={() => {
        getEvents().then(xs => {
          setEvents(xs);
        });
      }}
    />
  );
};
