//
//  QuizService.swift
//  QuizzleHub Avi
//
//  Created by Вячеслав on 8/21/25.
//

import Foundation

class QuizService: ObservableObject {
    @Published var quizzes: [Quiz] = []
    
    init() {
        loadQuizzes()
    }
    
    private func loadQuizzes() {
        quizzes = createSampleQuizzes()
    }
    
    func getQuizzes(for category: QuizCategory? = nil, difficulty: Difficulty? = nil) -> [Quiz] {
        var filteredQuizzes = quizzes
        
        if let category = category {
            filteredQuizzes = filteredQuizzes.filter { $0.category == category }
        }
        
        if let difficulty = difficulty {
            filteredQuizzes = filteredQuizzes.filter { $0.difficulty == difficulty }
        }
        
        return filteredQuizzes
    }
    
    func getQuiz(by id: UUID) -> Quiz? {
        return quizzes.first { $0.id == id }
    }
    
    func getFeaturedQuizzes() -> [Quiz] {
        return Array(quizzes.prefix(3))
    }
    
    private func createSampleQuizzes() -> [Quiz] {
        return [
            // Business Strategy Quizzes
            Quiz(
                title: "Strategic Planning Fundamentals",
                category: .businessStrategy,
                description: "Test your knowledge of core strategic planning principles and frameworks used by successful companies.",
                difficulty: .beginner,
                estimatedTime: 8,
                questions: [
                    Question(
                        text: "What is the primary purpose of a SWOT analysis in strategic planning?",
                        options: [
                            "To analyze financial performance",
                            "To identify Strengths, Weaknesses, Opportunities, and Threats",
                            "To create marketing campaigns",
                            "To manage employee performance"
                        ],
                        correctAnswerIndex: 1,
                        explanation: "SWOT analysis helps organizations understand their internal strengths and weaknesses while identifying external opportunities and threats."
                    ),
                    Question(
                        text: "Which strategic framework focuses on creating uncontested market space?",
                        options: [
                            "Porter's Five Forces",
                            "Blue Ocean Strategy",
                            "BCG Matrix",
                            "Ansoff Matrix"
                        ],
                        correctAnswerIndex: 1,
                        explanation: "Blue Ocean Strategy aims to create new market spaces where competition is irrelevant, rather than competing in existing markets."
                    ),
                    Question(
                        text: "What does the term 'competitive advantage' mean in business strategy?",
                        options: [
                            "Having more employees than competitors",
                            "Being located in a better area",
                            "Having unique capabilities that create superior value",
                            "Having lower prices than competitors"
                        ],
                        correctAnswerIndex: 2,
                        explanation: "Competitive advantage comes from unique resources, capabilities, or positions that allow a company to outperform competitors consistently."
                    ),
                    Question(
                        text: "In Porter's Five Forces model, which force examines the power of customers?",
                        options: [
                            "Threat of new entrants",
                            "Bargaining power of buyers",
                            "Threat of substitutes",
                            "Competitive rivalry"
                        ],
                        correctAnswerIndex: 1,
                        explanation: "Bargaining power of buyers analyzes how much influence customers have over pricing and terms in the industry."
                    ),
                    Question(
                        text: "What is a key characteristic of a well-defined business strategy?",
                        options: [
                            "It focuses on short-term profits only",
                            "It includes clear choices about where to compete and how to win",
                            "It avoids taking any risks",
                            "It copies successful competitors exactly"
                        ],
                        correctAnswerIndex: 1,
                        explanation: "Effective strategy involves making clear choices about target markets, value propositions, and how to achieve sustainable competitive advantage."
                    )
                ]
            ),
            
            Quiz(
                title: "Market Trends 2024",
                category: .marketTrends,
                description: "Stay updated with the latest market trends and consumer behavior patterns shaping business today.",
                difficulty: .intermediate,
                estimatedTime: 10,
                questions: [
                    Question(
                        text: "Which technology trend is most significantly impacting customer service in 2024?",
                        options: [
                            "Virtual Reality",
                            "Artificial Intelligence and Chatbots",
                            "Blockchain",
                            "3D Printing"
                        ],
                        correctAnswerIndex: 1,
                        explanation: "AI-powered chatbots and customer service automation are revolutionizing how businesses interact with customers, providing 24/7 support and personalized experiences."
                    ),
                    Question(
                        text: "What is driving the growth of the subscription economy?",
                        options: [
                            "Lower product quality",
                            "Consumer preference for access over ownership",
                            "Government regulations",
                            "Decreased internet usage"
                        ],
                        correctAnswerIndex: 1,
                        explanation: "Consumers increasingly prefer accessing products and services when needed rather than owning them, driving growth in subscription-based business models."
                    ),
                    Question(
                        text: "Which demographic factor is most influencing workplace trends?",
                        options: [
                            "Gen Z entering the workforce",
                            "Baby Boomers retiring",
                            "Millennials becoming managers",
                            "All of the above"
                        ],
                        correctAnswerIndex: 3,
                        explanation: "Multiple generational shifts are simultaneously affecting workplace expectations, communication styles, and organizational structures."
                    ),
                    Question(
                        text: "What is 'social commerce' in the context of current market trends?",
                        options: [
                            "Shopping in physical stores with friends",
                            "Buying and selling directly through social media platforms",
                            "Community-owned businesses",
                            "Charitable shopping initiatives"
                        ],
                        correctAnswerIndex: 1,
                        explanation: "Social commerce involves conducting e-commerce transactions directly within social media platforms, integrating shopping with social interaction."
                    ),
                    Question(
                        text: "Which sustainability trend is most impacting consumer purchasing decisions?",
                        options: [
                            "Circular economy principles",
                            "Carbon-neutral shipping",
                            "Sustainable packaging",
                            "All of the above"
                        ],
                        correctAnswerIndex: 3,
                        explanation: "Consumers are increasingly considering multiple sustainability factors when making purchasing decisions, from product lifecycle to environmental impact."
                    )
                ]
            ),
            
            Quiz(
                title: "Entrepreneurship Essentials",
                category: .entrepreneurship,
                description: "Explore the fundamentals of starting and growing a successful business venture.",
                difficulty: .beginner,
                estimatedTime: 12,
                questions: [
                    Question(
                        text: "What is the most critical factor for startup success?",
                        options: [
                            "Having a unique product",
                            "Securing large amounts of funding",
                            "Understanding and solving a real customer problem",
                            "Having an impressive team"
                        ],
                        correctAnswerIndex: 2,
                        explanation: "Successful startups focus on solving genuine problems that customers are willing to pay to have solved, rather than just creating innovative products."
                    ),
                    Question(
                        text: "What does MVP stand for in startup terminology?",
                        options: [
                            "Most Valuable Player",
                            "Minimum Viable Product",
                            "Maximum Value Proposition",
                            "Major Venture Partner"
                        ],
                        correctAnswerIndex: 1,
                        explanation: "MVP (Minimum Viable Product) is a development technique where a new product is developed with sufficient features to satisfy early adopters and validate a product idea."
                    ),
                    Question(
                        text: "Which funding stage typically comes first for startups?",
                        options: [
                            "Series A",
                            "Seed funding",
                            "Series B",
                            "IPO"
                        ],
                        correctAnswerIndex: 1,
                        explanation: "Seed funding is usually the first official equity funding stage, helping startups prove their concept and prepare for larger funding rounds."
                    ),
                    Question(
                        text: "What is 'bootstrapping' in entrepreneurship?",
                        options: [
                            "Using only external investors",
                            "Self-funding a business without external investment",
                            "Copying successful business models",
                            "Hiring only experienced employees"
                        ],
                        correctAnswerIndex: 1,
                        explanation: "Bootstrapping involves building a company using personal savings and revenue from the business rather than seeking external funding."
                    ),
                    Question(
                        text: "What is the primary purpose of a business model canvas?",
                        options: [
                            "To create detailed financial projections",
                            "To visualize and test key business model assumptions",
                            "To design marketing materials",
                            "To plan office layouts"
                        ],
                        correctAnswerIndex: 1,
                        explanation: "The business model canvas is a strategic management tool that helps entrepreneurs visualize, design, and test their business model on a single page."
                    )
                ]
            ),
            
            Quiz(
                title: "Innovation Management",
                category: .innovation,
                description: "Learn about managing innovation processes and fostering creative thinking in organizations.",
                difficulty: .advanced,
                estimatedTime: 15,
                questions: [
                    Question(
                        text: "What is the difference between incremental and disruptive innovation?",
                        options: [
                            "Incremental is cheaper, disruptive is more expensive",
                            "Incremental improves existing products, disruptive creates new markets",
                            "Incremental is faster, disruptive takes longer",
                            "There is no significant difference"
                        ],
                        correctAnswerIndex: 1,
                        explanation: "Incremental innovation improves existing products or services, while disruptive innovation creates entirely new markets or significantly changes existing ones."
                    ),
                    Question(
                        text: "Which innovation framework emphasizes 'failing fast and cheap'?",
                        options: [
                            "Stage-Gate Process",
                            "Lean Startup",
                            "Six Sigma",
                            "Waterfall Method"
                        ],
                        correctAnswerIndex: 1,
                        explanation: "Lean Startup methodology emphasizes rapid experimentation and learning from failures quickly and inexpensively to validate or pivot business ideas."
                    ),
                    Question(
                        text: "What is 'design thinking' in innovation management?",
                        options: [
                            "A method for creating attractive product designs",
                            "A human-centered approach to innovation and problem-solving",
                            "A way to reduce design costs",
                            "A technique for copying competitor designs"
                        ],
                        correctAnswerIndex: 1,
                        explanation: "Design thinking is a human-centered approach that integrates the needs of people, possibilities of technology, and requirements for business success."
                    ),
                    Question(
                        text: "Which factor is most important for creating an innovative organizational culture?",
                        options: [
                            "High salaries for employees",
                            "Psychological safety and tolerance for failure",
                            "Strict hierarchical structure",
                            "Focus only on successful projects"
                        ],
                        correctAnswerIndex: 1,
                        explanation: "Psychological safety allows team members to take risks, share ideas, and learn from failures without fear of punishment, which is essential for innovation."
                    ),
                    Question(
                        text: "What is 'open innovation'?",
                        options: [
                            "Making all company information public",
                            "Collaborating with external partners and communities for innovation",
                            "Having an open office layout",
                            "Allowing employees to work on any project"
                        ],
                        correctAnswerIndex: 1,
                        explanation: "Open innovation involves collaborating with external organizations, customers, suppliers, and even competitors to accelerate internal innovation and expand markets."
                    )
                ]
            ),
            
            Quiz(
                title: "Leadership in the Digital Age",
                category: .leadership,
                description: "Explore modern leadership principles and skills needed to lead teams in today's digital workplace.",
                difficulty: .intermediate,
                estimatedTime: 11,
                questions: [
                    Question(
                        text: "What is the key characteristic of transformational leadership?",
                        options: [
                            "Maintaining the status quo",
                            "Inspiring followers to exceed their own self-interests for the organization",
                            "Focusing solely on task completion",
                            "Avoiding change whenever possible"
                        ],
                        correctAnswerIndex: 1,
                        explanation: "Transformational leaders inspire and motivate followers to achieve extraordinary outcomes while developing their own leadership capacity."
                    ),
                    Question(
                        text: "Which leadership skill is most important for remote team management?",
                        options: [
                            "Micromanagement",
                            "Clear communication and trust-building",
                            "Physical presence",
                            "Technical expertise"
                        ],
                        correctAnswerIndex: 1,
                        explanation: "Remote leadership requires excellent communication skills and the ability to build trust without face-to-face interaction."
                    ),
                    Question(
                        text: "What does 'emotional intelligence' mean in leadership context?",
                        options: [
                            "Being emotional in decision-making",
                            "The ability to understand and manage emotions in oneself and others",
                            "Avoiding emotional situations",
                            "Making decisions based on feelings alone"
                        ],
                        correctAnswerIndex: 1,
                        explanation: "Emotional intelligence involves self-awareness, self-regulation, empathy, and social skills that help leaders navigate interpersonal relationships effectively."
                    ),
                    Question(
                        text: "Which approach best describes servant leadership?",
                        options: [
                            "Leaders should be served by their followers",
                            "Leaders should serve their followers' development and well-being",
                            "Leaders should only serve customers",
                            "Leadership is about being servile"
                        ],
                        correctAnswerIndex: 1,
                        explanation: "Servant leadership focuses on serving others first, helping followers grow and perform as highly as possible while achieving organizational goals."
                    ),
                    Question(
                        text: "How should leaders handle failure in their teams?",
                        options: [
                            "Punish those responsible immediately",
                            "Ignore failures and move on",
                            "Use failures as learning opportunities and support recovery",
                            "Blame external factors only"
                        ],
                        correctAnswerIndex: 2,
                        explanation: "Effective leaders treat failures as learning opportunities, help teams analyze what went wrong, and support them in developing better approaches."
                    )
                ]
            ),
            
            Quiz(
                title: "Financial Literacy for Business",
                category: .finance,
                description: "Master essential financial concepts every business professional should understand.",
                difficulty: .beginner,
                estimatedTime: 9,
                questions: [
                    Question(
                        text: "What is the difference between revenue and profit?",
                        options: [
                            "They are the same thing",
                            "Revenue is total income, profit is revenue minus expenses",
                            "Profit is always higher than revenue",
                            "Revenue includes expenses, profit doesn't"
                        ],
                        correctAnswerIndex: 1,
                        explanation: "Revenue is the total amount of money earned from sales, while profit is what remains after subtracting all business expenses from revenue."
                    ),
                    Question(
                        text: "What does ROI stand for and measure?",
                        options: [
                            "Return on Investment - measures profitability of an investment",
                            "Rate of Interest - measures loan costs",
                            "Revenue over Income - measures business growth",
                            "Risk of Investment - measures investment safety"
                        ],
                        correctAnswerIndex: 0,
                        explanation: "ROI (Return on Investment) measures the efficiency of an investment by comparing the gain or loss relative to its cost."
                    ),
                    Question(
                        text: "What is cash flow in business?",
                        options: [
                            "The total amount of money a company has",
                            "The movement of money in and out of a business",
                            "Only the money coming into a business",
                            "The profit a company makes"
                        ],
                        correctAnswerIndex: 1,
                        explanation: "Cash flow refers to the net amount of cash moving into and out of a business, crucial for maintaining operations and growth."
                    ),
                    Question(
                        text: "Which financial statement shows a company's assets, liabilities, and equity?",
                        options: [
                            "Income Statement",
                            "Cash Flow Statement",
                            "Balance Sheet",
                            "Budget Report"
                        ],
                        correctAnswerIndex: 2,
                        explanation: "The balance sheet provides a snapshot of a company's financial position at a specific point in time, showing assets, liabilities, and equity."
                    ),
                    Question(
                        text: "What is the break-even point for a business?",
                        options: [
                            "When revenue equals expenses",
                            "When profit is maximized",
                            "When cash flow is positive",
                            "When all debts are paid"
                        ],
                        correctAnswerIndex: 0,
                        explanation: "The break-even point is where total revenue equals total expenses, meaning the business neither makes a profit nor incurs a loss."
                    )
                ]
            )
        ]
    }
}
