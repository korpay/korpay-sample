import { createFileRoute } from '@tanstack/react-router'

export const Route = createFileRoute('/fail')({
  component: RouteComponent,
})

function RouteComponent() {
  return <div>결제 실패</div>
}
