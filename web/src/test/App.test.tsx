import { describe, it, expect } from 'vitest';
import { render, screen, fireEvent } from '@testing-library/react';
import App from '../App';

describe('MindBridge React Web App', () => {
  it('renders landing page with title and hero elements', () => {
    render(<App />);

    expect(screen.getByRole('banner')).toBeInTheDocument();
    expect(
      screen.getByRole('heading', { level: 1, name: /A little more room to understand/i })
    ).toBeInTheDocument();
    expect(screen.getByText(/Mental wellbeing, made more accessible/i)).toBeInTheDocument();
    expect(screen.getByRole('contentinfo')).toBeInTheDocument();
  });

  it('toggles mobile menu accessibility attributes', () => {
    render(<App />);

    const menuToggle = screen.getByRole('button', { name: /Open navigation/i });
    expect(menuToggle).toHaveAttribute('aria-expanded', 'false');

    fireEvent.click(menuToggle);
    expect(menuToggle).toHaveAttribute('aria-expanded', 'true');
    expect(screen.getByRole('button', { name: /Close navigation/i })).toBeInTheDocument();

    fireEvent.click(menuToggle);
    expect(menuToggle).toHaveAttribute('aria-expanded', 'false');
  });

  it('switches languages between English and Hausa', () => {
    render(<App />);

    // Default English
    expect(screen.getByRole('link', { name: /Why MindBridge/i })).toBeInTheDocument();

    // Switch to Hausa
    const haBtn = screen.getByRole('button', { name: 'HA' });
    fireEvent.click(haBtn);

    expect(screen.getByRole('link', { name: /Dalilin MindBridge/i })).toBeInTheDocument();
    expect(screen.getByText(/LAFIYAR ZUCIYA DA TAWASUDI/i)).toBeInTheDocument();

    // Switch back to English
    const enBtn = screen.getByRole('button', { name: 'EN' });
    fireEvent.click(enBtn);

    expect(screen.getByRole('link', { name: /Why MindBridge/i })).toBeInTheDocument();
  });

  it('expands and collapses FAQ accordion items with accessible keyboard/click controls', () => {
    render(<App />);

    const faqButton = screen.getByRole('button', { name: /Is MindBridge a therapy app\?/i });
    expect(faqButton).toHaveAttribute('aria-expanded', 'false');

    fireEvent.click(faqButton);
    expect(faqButton).toHaveAttribute('aria-expanded', 'true');
    expect(
      screen.getByText(/It does not provide therapy or replace a qualified professional/i)
    ).toBeInTheDocument();

    fireEvent.click(faqButton);
    expect(faqButton).toHaveAttribute('aria-expanded', 'false');
  });

  it('opens and closes the interactive Web Prototype view', () => {
    render(<App />);

    const tryButtons = screen.getAllByRole('button', { name: /Try Interactive Prototype/i });
    fireEvent.click(tryButtons[0]);

    // Prototype should now be active
    expect(screen.getByText(/MINDBRIDGE WEB APP PROTOTYPE/i)).toBeInTheDocument();
    expect(screen.getByText(/Good to have you here\./i)).toBeInTheDocument();

    // Navigate to Learn tab
    const learnTab = screen.getByRole('tab', { name: /Learn/i });
    fireEvent.click(learnTab);
    expect(screen.getByText(/Understanding depression/i)).toBeInTheDocument();

    // Navigate to Check-in tab
    const checkInTab = screen.getByRole('tab', { name: /Check-in/i });
    fireEvent.click(checkInTab);
    expect(screen.getByText(/How are you feeling today\?/i)).toBeInTheDocument();

    // Return to Landing Page
    const closeBtns = screen.getAllByRole('button', { name: /Return to Landing Page/i });
    fireEvent.click(closeBtns[0]);

    expect(
      screen.getByRole('heading', { level: 1, name: /A little more room to understand/i })
    ).toBeInTheDocument();
  });

  it('supports selecting a mood in the check-in screen', () => {
    render(<App />);

    // Open prototype and go to check-in
    const tryButtons = screen.getAllByRole('button', { name: /Try Interactive Prototype/i });
    fireEvent.click(tryButtons[0]);

    const checkInTab = screen.getByRole('tab', { name: /Check-in/i });
    fireEvent.click(checkInTab);

    // Select "Calm"
    const calmBtn = screen.getByText('Calm');
    fireEvent.click(calmBtn);

    expect(screen.getByText(/Thank you for pausing\./i)).toBeInTheDocument();
    expect(screen.getByText(/You selected: Calm/i)).toBeInTheDocument();
  });
});
