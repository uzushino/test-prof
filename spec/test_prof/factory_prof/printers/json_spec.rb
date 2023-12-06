# frozen_string_literal: true

describe TestProf::FactoryProf::Printers::Json do
  subject { described_class }

  describe "#dump" do
    before do
      allow(File).to receive(:write)
      allow(TestProf).to receive(:artifact_path).and_return("test-prof.result.json")
      allow(TestProf).to receive(:now).and_return(2.0)
    end

    it "write json report" do
      stacks = []
      stacks << %i[user account]
      stacks << %i[user account]
      stacks << %i[post account user account]
      stacks << %i[comment post]
      stacks << %i[comment user account]
      stacks << [:user]
      stacks << [:account]

      subject.dump(
        TestProf::FactoryProf::Result.new(
          stacks,
          {
            user: {name: :user, total_count: 5, total_time: 1.0, top_level_count: 5, top_level_time: 0.1},
            account: {name: :account, total_count: 6, total_time: 2.0, top_level_count: 6, top_level_time: 0.2},
            comment: {name: :comment, total_count: 2, total_time: 3.0, top_level_count: 2, top_level_time: 0.3},
            name: {name: :post, total_count: 2, total_time: 4.0, top_level_count: 0, top_level_time: 0.4}
          }
        ),
        start_time: 0
      )

      outpath = TestProf.artifact_path("test-prof.result.json")
      expect(File).to have_received(:write).with(outpath, include({
        total_count: 15,
        total_top_level_count: 13,
        total_time: "00:01.000",
        total_run_time: "00:02.000",
        total_uniq_factories: 4
      })).once
    end
  end
  # rubocop:enable Style/BracesAroundHashParameters
end
