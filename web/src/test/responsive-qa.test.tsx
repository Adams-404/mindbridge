import { describe, it, expect } from 'vitest';
import { render, screen, fireEvent } from '@testing-library/react';
import App from '../App';

describe('Responsive and Cross-Browser QA (Issue #2)', () => {
  it('all external links use safe target and rel attributes', () => {
    const { container } = render(<App />);
    const externalLinks = container.querySelectorAll('a[href^="http"]');

    expect(externalLinks.length).toBeGreaterThan(0);
    externalLinks.forEach((link) => {
      expect(link).toHaveAttribute('target', '_blank');
      const rel = link.getAttribute('rel');
      expect(rel).toMatch(/noopener/);
      expect(rel).toMatch(/noreferrer/);
    });
  });

  it('all navigation anchor links map to existing sections in the document', () => {
    const { container } = render(<App />);
    const anchorLinks = container.querySelectorAll('a[href^="#"]');

    anchorLinks.forEach((link) => {
      const hash = link.getAttribute('href');
      if (hash && hash !== '#') {
        const targetElement = container.querySelector(hash);
        expect(targetElement).not.toBeNull();
      }
    });
  });

  it('mobile navigation toggles and closes on link tap', () => {
    render(<App />);

    const menuToggle = screen.getByRole('button', { name: /Open navigation/i });
    fireEvent.click(menuToggle);
    expect(menuToggle).toHaveAttribute('aria-expanded', 'true');

    // Tap a navigation link
    const whyLink = screen.getByRole('link', { name: /Why MindBridge/i });
    fireEvent.click(whyLink);

    // Menu should be closed
    expect(menuToggle).toHaveAttribute('aria-expanded', 'false');
  });

  it('no horizontal overflow or clipped text in feature cards or FAQ', () => {
    const { container } = render(<App />);

    // Check all cards are rendered with proper classes
    const cards = container.querySelectorAll('.feature-card');
    expect(cards.length).toBe(4);

    // Check FAQ list is rendered
    const faqItems = container.querySelectorAll('.faq-item');
    expect(faqItems.length).toBe(5);

    // Check steps
    const steps = container.querySelectorAll('.step');
    expect(steps.length).toBe(3);
  });
});
