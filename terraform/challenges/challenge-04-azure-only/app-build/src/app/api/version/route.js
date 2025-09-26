import { NextResponse } from 'next/server'

export async function GET() {
  try {
    // Get versions from package.json and process.version
    const packageJson = require('../../../../package.json')
    
    const versionInfo = {
      nodejs: process.version,
      nextjs: packageJson.dependencies.next,
      application: {
        name: packageJson.name,
        version: packageJson.version
      },
      vulnerability: {
        cve: "CVE-2025-29927",
        description: "Next.js Middleware Authorization Bypass",
        affected_versions: {
          "13.x": ">= 13.0.0, < 13.5.9",
          "14.x": ">= 14.0.0, < 14.2.25", 
          "15.x": ">= 15.0.0, < 15.2.3",
          "12.x": ">= 11.1.4, < 12.3.5"
        },
        current_status: packageJson.dependencies.next.includes('13.4.0') ? "VULNERABLE" : "UNKNOWN"
      },
      timestamp: new Date().toISOString()
    }

    return NextResponse.json(versionInfo, {
      status: 200,
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Cache-Control': 'no-cache'
      }
    })
    
  } catch (error) {
    return NextResponse.json(
      { 
        error: 'Unable to retrieve version information',
        message: error.message 
      },
      { status: 500 }
    )
  }
}
