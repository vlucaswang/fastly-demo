# Fastly Demo Solution Design

## Overview

This document outlines the design of a demo solution that showcases the capabilities of Fastly's edge cloud platform. The solution is designed to be simple, yet effective in demonstrating the key features and benefits of using Fastly for content delivery and edge computing.

## Objectives

- To create a demo website that showcases the capabilities of Fastly's edge cloud platform.
- The demo website should cost less than $5 per month to run.
- The demo website should be easy to set up and maintain.
- The demo website should be able to handle a moderate amount of traffic.

## Architecture

The architecture of the demo solution consists of the following components:

- **Fastly CDN**: The content delivery network that will cache and deliver the demo website's content.
- **Website Backend**: The backend server that will serve the demo website's content. This can be a simple static website hosted on a cloud provider like AWS S3, or a more complex dynamic website hosted on a cloud provider like AWS EC2.
- **Domain Name**: A domain name that will be used to access the demo website. This can be a free domain name from a provider like Freenom, or a paid domain name from a provider like GoDaddy.
- **SSL Certificate**: An SSL certificate that will be used to secure the demo website. This can be a free SSL certificate from a provider like Let's Encrypt.

## Diagram

```mermaid
graph LR
    User(User) -->|Requests website| DNS[DNS Provider]
    DNS -->|Resolves domain name<br>fastly-demo.vlucaswang.com| Fastly[Fastly CDN]
    Cache -->|Deliver content| User

    subgraph "Fastly Edge Cloud"
        Fastly -->|Cache HIT| Cache[Edge Cache]
        Fastly -->|Return content| User
    end

    subgraph "Origin Infrastructure"
        Fastly -->|Cache MISS| Origin
        Origin[Origin Backend] -->|Return content| Fastly
    end

    subgraph "Security Layer"
        TLS[TLS Certificate<br>Certificate Authority] -.->|Secures| Fastly
        Domain[Domain Name<br>fastly-demo.example.com] -.->|Points to| Fastly
    end

    classDef user fill:#f9f,stroke:#333,stroke-width:2px;
    classDef fastly fill:#bbf,stroke:#33f,stroke-width:2px;
    classDef security fill:#bfb,stroke:#3f3,stroke-width:1px;

    class User user;
    class Fastly,Cache fastly;
    class TLS,Domain security;
```

## Current State/Future State

```mermaid
graph TD
    User(User) -->|Requests website| DNS[DNS Provider]
    DNS -->|Resolves domain name| Router1[Home Router]
    DNS -->|Resolves domain name| Fastly[Fastly CDN]
    Current_State --> Future_State

    subgraph "Current_State"
        Router1 -->|Port forwarding| Site1[Mock HTTP]
        Router1 -->|Port forwarding| Site2[HTTPBin]

        subgraph "Home Server"
            Site1
            Site2
        end
    end

    subgraph "Future_State"
        Fastly -->|Backend| Router2[Home Router]
        Router2 -->|Port forwarding| Nginx2[Nginx Proxy]

        subgraph "Home Server"
            Nginx2 -->|Reversed Proxy| Site3[Mock HTTP]
            Nginx2 -->|Reversed Proxy| Site4[HTTPBin]
        end
    end

    classDef user fill:#f9f,stroke:#333,stroke-width:2px;
    classDef fastly fill:#bbf,stroke:#33f,stroke-width:2px;
    classDef infra fill:#bfb,stroke:#3f3,stroke-width:1px;

    class User user;
    class Fastly,DNS fastly;
    class Site1,Site2,Site3,Site4,Nginx2,Router1,Router2 infra;
```