import type { Metadata } from "next";
import React from "react";

export const metadata: Metadata = {
  title: "korpay-sample"
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="ko">
      <body>
        {children}
      </body>
    </html>
  );
}
