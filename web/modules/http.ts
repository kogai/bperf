type Host = string;

interface HttpClient {
  get: <R>(path: string) => Promise<R>;
}

const createClient = <R>(host: string): HttpClient => ({
  get<R>(path: string): Promise<R> {
    return fetch(`${host}/${path}`, {
      method: "GET"
    })
      .then(res => res.json())
      .then((res: R) => res);
  }
});

const client = createClient("http://localhost:5000");

export type Event = {
  eventType: string;
  time: number;
};

export const getEvents = () => client.get<Event[]>("events");
