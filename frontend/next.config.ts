import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  async rewrites() {
    return [
      {
        source: "/api/:path*",
        destination: process.env.NODE_ENV === "development" && process.env.DOCKER_ENV
          ? "http://backend:3000/:path*"
          : "http://localhost:3000/:path*",
      },
    ];
  },
};

export default nextConfig;
