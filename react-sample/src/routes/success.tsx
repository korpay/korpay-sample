import { createFileRoute } from '@tanstack/react-router'

export const Route = createFileRoute('/success')({
  component: RouteComponent,
})

function RouteComponent() {
  return <div>결제 성공</div>
}
