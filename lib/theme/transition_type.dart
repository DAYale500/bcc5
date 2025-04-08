// lib/theme/transition_type.dart

enum TransitionType {
  instant,
  slide,
  fade,
  scale,
  fadeScale,
  rotation, // Rotates in (good for playful or tool-related UIs)
  slideUp, // Slide from bottom to top
  slideDown, // Slide from top to bottom
  slideLeft, // Slide from right to left (RTL friendly)
  slideRight, // Slide from left to right
  slide3D, // Simulated 3D slide with depth transform
  cube, // 3D cube rotation
  flip, // Horizontal or vertical card flip
  zoomIn, // Like scale, but focuses from a small origin point
  zoomOut, // Starts zoomed in, shrinks to position
  blurFade, // Blur in/out while fading
  morph, // Morphing shape (e.g., FAB to full screen)
  carousel, // Swipe-style transition (like page view)
  sharedAxis, // Material motion shared axis (x, y, z)
  ripple, // Expands like a ripple from the center/tap
  delayFade, // Fades in with intentional delay for layered content
  staggered, // Choreographed entry of multiple widgets
}
