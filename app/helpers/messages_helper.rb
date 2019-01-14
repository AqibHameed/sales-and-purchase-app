module MessagesHelper

  def new_messages(messages)
    messages.map {|m| m if m.proposal && (m.proposal.status == 'negotiated' or m.proposal.status == 'new_proposal') && !(m.proposal.negotiations.last.whose == current_company)}.compact
  end

  def new_messages_payment(messages, payment_messages)
    messages = messages.map {|m| m if m.proposal && (m.proposal.status == 'negotiated' or m.proposal.status == 'new_proposal') && !(m.proposal.negotiations.last.whose == current_company)}.compact
    messages << payment_messages
    messages.flatten
  end

  def negotiated_messages(messages)
    messages.map {|m| m if m.proposal && m.proposal.status == 'negotiated' && m.proposal.negotiations.present? && (m.proposal.negotiations.last.whose == current_company)}.compact
  end

  def negotiation_messages(messages)
    messages.map {|m| m if m.proposal && (m.proposal.status == 'negotiated' or (m.proposal.status == 'new_proposal' && (m.subject == 'Buyer sent a new proposal.' or m.subject == 'Seller sent a new proposal.'))) && m.proposal.negotiations.present? && (m.proposal.negotiations.last.whose == current_company)}.compact
  end
end

