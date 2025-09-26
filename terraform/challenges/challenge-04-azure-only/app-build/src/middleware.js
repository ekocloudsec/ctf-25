import { NextResponse } from 'next/server'

export function middleware(request) {
  const { pathname } = request.nextUrl
  
  // Skip middleware for static files, login, and version endpoint
  if (pathname.startsWith('/_next/') || 
      pathname.startsWith('/favicon.ico') ||
      pathname === '/login' ||
      pathname === '/api/version') {
    return NextResponse.next()
  }

  // CVE-2025-29927: Authorization Bypass vulnerability
  // COMMENTED FOR TESTING REAL VULNERABILITY:
  // const subrequest = request.headers.get('x-middleware-subrequest')
  // if (subrequest === 'middleware:middleware:middleware:middleware:middleware') {
  //   // Vulnerability: bypass authentication completely
  //   return NextResponse.next()
  // }

  // REMOVED COOKIE AUTHENTICATION - Force users to use only the vulnerability
  // No normal authentication path - only CVE-2025-29927 bypass should work
  return NextResponse.redirect(new URL('/login', request.url))
}

export const config = {
  matcher: [
    '/((?!_next/static|_next/image|favicon.ico).*)',
  ],
}
