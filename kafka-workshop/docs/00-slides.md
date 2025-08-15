---
marp: true
theme: default
class: lead
paginate: true
backgroundColor: #ffffff
color: #333333
header: "Apache Kafka Fundamentals"
footer: "Event Streaming Workshop"
---

<style>
section {
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  background-color: #ffffff;
  color: #333333;
  font-size: 18px;
}

h1 {
  color: #2c3e50;
  border-bottom: 3px solid #3498db;
  padding-bottom: 10px;
  font-size: 2em;
}

h2 {
  color: #34495e;
  margin-bottom: 20px;
  font-size: 1.4em;
}

h3 {
  color: #298bca;
  font-size: 1.2em;
}

.lead h1 {
  font-size: 2.5em;
  text-align: center;
  margin-bottom: 0.5em;
}

.lead h2 {
  font-size: 1.5em;
  text-align: center;
  color: #7f8c8d;
  font-weight: normal;
}

code, pre {
  background-color: #f8f9fa;
  border: 1px solid #e9ecef;
  border-radius: 5px;
  font-size: 14px;
}

pre {
  padding: 15px;
  line-height: 1.4;
}

table {
  border-collapse: collapse;
  width: 100%;
  margin: 20px 0;
  font-size: 16px;
}

th, td {
  border: 1px solid #dee2e6;
  padding: 10px;
  text-align: left;
}

th {
  background-color: #f8f9fa;
  font-weight: bold;
}

.highlight {
  background-color: #fff3cd;
  padding: 15px;
  border-radius: 5px;
  border-left: 4px solid #ffc107;
  margin: 15px 0;
}

.success {
  background-color: #d4edda;
  padding: 15px;
  border-radius: 5px;
  border-left: 4px solid #28a745;
  margin: 15px 0;
}

.info {
  background-color: #d1ecf1;
  padding: 15px;
  border-radius: 5px;
  border-left: 4px solid #17a2b8;
  margin: 15px 0;
}

.warning {
  background-color: #f8d7da;
  padding: 15px;
  border-radius: 5px;
  border-left: 4px solid #dc3545;
  margin: 15px 0;
}

ul li {
  margin: 6px 0;
}

.diagram-box {
  background-color: #f8f9fa;
  border: 2px solid #dee2e6;
  border-radius: 8px;
  padding: 20px;
  margin: 20px 0;
  font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace;
  white-space: pre;
}

.concept-box {
  background-color: #f8f9fa;
  border: 1px solid #dee2e6;
  border-radius: 5px;
  padding: 15px;
  margin: 10px 0;
}
</style>

# Apache Kafka Fundamentals
## The Complete Guide to Distributed Event Streaming

---

# Agenda
1. The Birth of Kafka
2. What is Apache Kafka?
3. Core Kafka Architecture
4. Topics & Partitions
5. Replication & Fault Tolerance
6. ZooKeeper vs KRaft
7. How Kafka Stores Data
8. Producers
9. Consumers & Consumer Groups
10. Kafka Connect
11. Kafka Streams
12. Kafka Use Cases
13. Monitoring & Metrics
14. Security in Kafka
15. Hands-on Demo
16. Wrap-Up

---

# The Birth of Kafka
## 2010–2011 at LinkedIn

<div class="two-columns">
<div>

### The Problem
- Billions of events/day
- Real-time analytics needed
- Traditional brokers couldn’t scale

### The Solution Team
- Jay Kreps
- Neha Narkhede
- Jun Rao

</div>
</div>


---

## Kafka Timeline

### Timeline
| Year | Milestone |
|------|-----------|
| 2011 | Open-sourced Kafka |
| 2013 | Apache Top-Level Project |
| 2014 | Confluent founded |
| 2016 | Kafka Streams introduced |
| 2020 | KRaft mode (no ZooKeeper) |

---

# What is Apache Kafka?

<div class="three-columns">
<div class="info">
<strong>Definition</strong><br/>
Apache Kafka is a <em>distributed, fault-tolerant event streaming platform</em> that stores, processes, and transports real-time data at scale.
</div>
<div class="info">
<strong>Core Roles</strong><br/>
Publish/subscribe • Durable storage • Stream processing
</div>
<div class="info">
<strong>Analogy</strong><br/>
Like a high-speed, persistent <em>data conveyor belt</em> where many apps can place and pick up packages.
</div>
</div>

---

# Core Kafka Architecture

<div class="diagram-box">
[Producer Apps]  --->  [Kafka Brokers Cluster]  --->  [Consumer Apps]
                          (Topics & Partitions)
</div>

**Key Components**
- **Producers** send messages to topics
- **Brokers** store and serve messages
- **Topics** are named categories of messages
- **Partitions** are parallel units of a topic
- **Consumers** read messages from topics
- **Cluster Coordination** via ZooKeeper or KRaft

---

# Topics & Partitions

<div class="diagram-box">
Topic: user-events
 ├─ Partition 0: Msg1 → Msg2 → Msg3
 ├─ Partition 1: Msg4 → Msg5 → Msg6
 └─ Partition 2: Msg7 → Msg8 → Msg9
</div>

- **Topics**: Logical streams of data  
- **Partitions**: Scale & parallelize consumption  
- **Keys**: Route to partitions; ordering within a partition

---

# Replication & Fault Tolerance

<div class="diagram-box">
Partition 0 (Replication Factor = 3)
 ┌─────────┐ Leader   (Broker 1)
 ├─────────┤ Follower (Broker 2)
 └─────────┘ Follower (Broker 3)
</div>

- **Leader** handles reads/writes; **followers** replicate
- **ISR**: In-Sync Replicas
- Prevent data loss: `unclean.leader.election.enable=false`
- Best practice: `min.insync.replicas=2` with RF=3

---

# ZooKeeper vs KRaft

<div class="two-columns">
<div class="concept-box">
<strong>ZooKeeper</strong><br/>
External service for metadata & leader election.<br/>
More components to run and manage.
</div>
<div class="concept-box">
<strong>KRaft (Kafka Raft)</strong><br/>
Built-in consensus; simpler ops, faster startup, better scalability.<br/>
Default in Kafka 3.5+.
</div>
</div>

---

# How Kafka Stores Data

<div class="two-columns">
<div class="concept-box">
<strong>Commit Log</strong><br/>
Append-only files on disk. Retain by <em>time</em> or <em>size</em>; optional <em>log compaction</em> keeps latest record per key.
</div>
<div class="concept-box">
<strong>Segments</strong><br/>
Partitions split into segments. Old segments are deleted or compacted based on policy.
</div>
</div>

---

# Producers

<div class="two-columns">
<div>

### What is a Producer?
An application that publishes messages to Kafka topics.

### Partitioning
- **Key-based** → same key → same partition
- **No key** → round-robin distribution

</div>
<div>

### Key Settings
```properties
acks=all
enable.idempotence=true
compression.type=snappy
```
</div>
</div>

---

# Consumers & Consumer Groups

<div class="diagram-box">
Topic: orders (6 partitions)
Group: analytics
 ┌───────────┬───────────┬───────────┐
 │ Consumer1 │ Consumer2 │ Consumer3 │
 │ [P0, P1]  │ [P2, P3]  │ [P4, P5]  │
 └───────────┴───────────┴───────────┘
</div>

- Each **group** sees all messages
- Within a group, a **partition** is consumed by one member
- **Offsets** track read position

---

# Kafka Connect

<div class="two-columns">
<div class="concept-box">
<strong>Purpose</strong><br/>
Integrate Kafka with external systems <em>without custom code</em>.
</div>
<div class="concept-box">
<strong>Types</strong><br/>
Source connectors (import) • Sink connectors (export)<br/>
Runs in standalone or distributed mode.
</div>
</div>

---

# Kafka Streams

<div class="two-columns">
<div class="concept-box">
<strong>Purpose</strong><br/>
Build real-time applications directly on Kafka.
</div>
<div class="concept-box">
<strong>Highlights</strong><br/>
Java/Scala library • Stateful ops (aggregations, joins, windows) • Exactly-once semantics • Scales with partitions.
</div>
</div>

---

# Kafka Use Cases

<div class="two-columns">
<div class="success">
<strong>Great Fit</strong><br/>
Event streaming (user activity, IoT)<br/>
Real-time analytics (fraud, dashboards)<br/>
Microservice communication (EDA)
</div>
<div class="warning">
<strong>Not Ideal</strong><br/>
Ultra low latency trading<br/>
Small simple queues<br/>
OLTP DB replacement
</div>
</div>

---

# Monitoring & Metrics

- Kafka CLI tools
- Prometheus + Grafana
- Confluent Control Center

**Watch:** Broker health • Topic/partition status • Consumer lag

---

# Security in Kafka

<div class="three-columns">
<div class="concept-box">
<strong>AuthN</strong><br/>
SASL/PLAIN • SASL/SCRAM • Kerberos • OAuth
</div>
<div class="concept-box">
<strong>Encryption</strong><br/>
TLS in transit
</div>
<div class="concept-box">
<strong>AuthZ</strong><br/>
ACLs per topic, group, and cluster resources
</div>
</div>

---

# Hands-On Demo

**We'll cover:**
- Creating topics
- Producing and consuming messages
- Observing replication
- Checking consumer lag

**Reference Handouts:**
- `01-basic-commands.md`
- `02-kcat-examples.md`
- `03-python-examples.md`
- `04-load-test-commands.md`

**We'll cover:**
- Creating topics
- Producing and consuming messages
- Observing replication
- Checking consumer lag

**Reference Handouts:**
- `01-basic-commands.md`
- `02-kcat-examples.md`
- `03-python-examples.md`
- `04-load-test-commands.md`

---

# Wrap-Up

We covered:
- Kafka basics & architecture
- Topics, partitions, replication
- Producers & consumers
- Storage model, Connect, Streams
- Use cases, monitoring, security

<div class="highlight">
Next: Hands-on practice & advanced configs
</div>

---

# Appendix: Config Highlights

<div class="three-columns">
<div>

**Producer**
```properties
acks=all
enable.idempotence=true
compression.type=snappy
```
</div>
<div>

**Consumer**
```properties
group.id=my-group
auto.offset.reset=earliest
```
</div>
<div>

**Broker**
```properties
default.replication.factor=3
min.insync.replicas=2
```
</div>
</div>
