module MessagesHelper

  def new_messages(messages)
    messages.map {|m| m if m.proposal && (m.proposal.status == 'negotiated' or m.proposal.status == 'new_proposal') && !(m.proposal.negotiations.last.whose == current_company)}.compact
  end

  def negotiated_messages(messages)
    messages.map {|m| m if m.proposal && m.proposal.status == 'negotiated' && (m.proposal.negotiations.last.whose == current_company)}.compact
  end
end

