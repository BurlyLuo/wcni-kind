https://cilium.io/blog/2019/08/20/cilium-16/

Load-balancing is typically done in one of the following ways:

The application performs client-side load-balancing and picks a destination endpoint itself. The benefit of this is that the cost of load-balancing is paid once upfront when a connection is established and no additional overhead exists for the lifetime of the connection. The downside of this approach is that this is not transparent to the application.

The network performs the load-balancing via a middle box by translating requests to a particular service IP. The advantage of this method over client-side load-balancing is the transparency. The application itself is not involved. However, the downside is that each network packet needs to have its IP addresses changed in both the request and response direction.

With Cilium 1.6, we are introducing socket-based load-balancing which combines the advantages of both approaches:

Transparent: Load-balancing remains 100% transparent to the application. Services are defined using standard Kubernetes service definitions.

Highly efficient: By performing the load-balancing at the socket level by translating the address inside the connect(2) system call, the cost of load-balancing is paid upfront when setting up the connection and no additional translation is needed for the duration of the connection afterwards. The performance is identical as if the the application talks directly to the backend.
