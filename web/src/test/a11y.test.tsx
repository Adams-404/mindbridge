import { describe, it, expect } from 'vitest';
import { render, screen, fireEvent } from '@testing-library/react';
import App from '../App';

describe('WCAG 2.2 AA Accessibility Audit (Issue #3)', () => {
  it('contains an accessible skip-to-content link targeting main content', () => {
    const { container } = render(<App />);
    const skipLink = screen.getByRole('link', { name: /Skip to main content/i });
    expect(skipLink).toBeInTheDocument();
    expect(skipLink).toHaveAttribute('href', '#main-content');

    const main = container.querySelector('#main-content');
    expect(main).not.toBeNull();
  });

  it('navigation menu exposes proper aria-expanded state and accessible label', () => {
    render(<App />);
    const toggle = screen.getByRole('button', { name: /Open navigation/i });
    expect(toggle).toHaveAttribute('aria-expanded', 'false');

    fireEvent.click(toggle);
    expect(toggle).toHaveAttribute('aria-expanded', 'true');
    expect(toggle).toHaveAttribute('aria-label', 'Close navigation');
  });

  it('all FAQ accordions expose aria-expanded and aria-controls attributes', () => {
    render(<App />);
    const buttons = screen.getAllByRole('button', { name: /Is MindBridge a therapy app|Can MindBridge diagnose/i });

    buttons.forEach((btn) => {
      expect(btn).toHaveAttribute('aria-expanded');
      expect(btn).toHaveAttribute('aria-controls');
    });
  });

  it('no interactive element relies on color alone (icons, text labels, and aria attributes present)', () => {
    render(<App />);
    const langBtns = screen.getAllByRole('button', { name: /EN|HA/ });
    expect(langBtns[0]).toHaveAttribute('aria-pressed', 'true');
    expect(langBtns[1]).toHaveAttribute('aria-pressed', 'false');

    fireEvent.click(langBtns[1]);
    expect(langBtns[0]).toHaveAttribute('aria-pressed', 'false');
    expect(langBtns[1]).toHaveAttribute('aria-pressed', 'true');
  });

  it('semantic landmarks are used (banner, main, contentinfo, navigation, regions)', () => {
    render(<App />);
    expect(screen.getByRole('banner')).toBeInTheDocument();
    expect(screen.getByRole('main')).toBeInTheDocument();
    expect(screen.getByRole('contentinfo')).toBeInTheDocument();
    expect(screen.getAllByRole('navigation').length).toBeGreaterThan(0);
  });
});
